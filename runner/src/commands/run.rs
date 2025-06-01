use crate::utils::{self, LanguageConfig};
use md5;
use regex::Regex;
use reqwest::blocking::Client;
use serde_yaml::{Mapping, Sequence, Value};
use std::collections::HashMap;
use std::env;
use std::fs;
use std::io::{self, BufRead};
use std::path::Path;
use std::process::{exit, Command, Stdio};

pub fn run(example_name: Option<String>, part: Option<usize>, confirmation: Option<bool>) {
    let mut context = RunContext::new(example_name, part, confirmation);

    if utils::has_devshell(&context.settings.language) {
        context.execute_solution_nix();
    } else {
        context.prepare_docker_container();
        context.execute_solution_docker();
    }

    if context.check_solution().is_none() {
        if context.submit_solution() {
            context.save_solution();
        }
    }
}

struct Settings {
    year: usize,
    day: usize,
    language: String,
    problem_path: String,
    solution_path: String,
    example_name: String,
    part: usize,
    language_config: LanguageConfig,
    confirmation: Option<bool>,
}

struct RunContext {
    settings: Settings,
    docker_image_ref: Option<String>,
    result: Option<String>,
    solutions_data: Option<Value>,
}

impl RunContext {
    fn new(example_name: Option<String>, part: Option<usize>, confirmation: Option<bool>) -> Self {
        let (year, day, lang) = utils::resolve_aoc_settings(None, None, None);
        RunContext {
            settings: Settings {
                year,
                day,
                language: lang.clone(),
                problem_path: format!("./problems/{}/{:02}", year, day),
                solution_path: format!("./solutions/{}/{:02}/{}", year, day, lang),
                language_config: utils::get_language_config(&lang).unwrap(),
                example_name: example_name.unwrap_or("input".to_string()),
                part: part.unwrap_or(1),
                confirmation,
            },
            docker_image_ref: None,
            result: None,
            solutions_data: None,
        }
    }

    fn prepare_docker_container(&mut self) {
        let solution_path = &self.settings.solution_path;
        let language = &self.settings.language;

        let dockerfile = Path::new(solution_path).join("Dockerfile");
        let docker_ref_file = Path::new(solution_path).join(".docker-image-ref");

        self.docker_image_ref = if dockerfile.exists() {
            Some(verify_dockerfile(&dockerfile, language))
        } else if docker_ref_file.exists() {
            Some(verify_docker_ref_file(&docker_ref_file))
        } else {
            Some(create_docker_ref_file(&docker_ref_file, language))
        }
    }

    fn execute_solution_docker(&mut self) {
        let full_command = format!(
            "{} /problem/{}.txt {}",
            &self.settings.language_config.run, &self.settings.example_name, &self.settings.part
        );

        let mut child = Command::new("docker")
            .arg("run")
            .arg("--rm")
            .arg("-t")
            .arg("-v")
            .arg(format!("{}:/problem", &self.settings.problem_path))
            .arg("-v")
            .arg(format!("{}:/solution", &self.settings.solution_path))
            .arg("-w")
            .arg("/solution")
            .arg(self.docker_image_ref.as_ref().unwrap())
            .arg("sh")
            .arg("-c")
            .arg(full_command)
            .stdout(Stdio::piped())
            .stderr(Stdio::inherit())
            .spawn()
            .expect("Failed to execute Docker container");

        let stdout = child.stdout.take().expect("Failed to capture stdout");
        let reader = io::BufReader::new(stdout);

        let mut last_line = None;
        for line in reader.lines() {
            let line = line.expect("Failed to read line");
            println!("{}", line);
            last_line = Some(line);
        }

        let status = child.wait().expect("Failed to wait for child process");

        if !status.success() {
            eprintln!(
                "Docker run failed with exit code {}",
                status.code().unwrap()
            );
            exit(1);
        }

        self.result = last_line;
    }

    fn execute_solution_nix(&mut self) {
        use std::fs;
        use std::path::PathBuf;

        // Construct the real path to the input file
        let input_path = fs::canonicalize(
            PathBuf::from(&self.settings.problem_path)
                .join(format!("{}.txt", &self.settings.example_name)),
        )
        .expect("Failed to resolve absolute input path");

        if !input_path.exists() {
            eprintln!("Input file not found: {}", input_path.display());
            exit(1);
        }

        // Construct the command line as defined in the language config
        let full_command = format!(
            "{} {} {}",
            &self.settings.language_config.run,
            input_path.display(),
            &self.settings.part
        );

        // Launch via nix develop in the solution dir
        let mut child = Command::new("nix")
            .arg("develop")
            .arg(format!(".#{}", self.settings.language))
            .arg("-c")
            .arg("sh")
            .arg("-c")
            .arg(&full_command)
            .current_dir(&self.settings.solution_path)
            .stdout(Stdio::piped())
            .stderr(Stdio::inherit())
            .spawn()
            .expect("Failed to start nix shell");

        let stdout = child.stdout.take().expect("Failed to capture stdout");
        let reader = io::BufReader::new(stdout);

        let mut last_line = None;
        for line in reader.lines() {
            let line = line.expect("Failed to read line");
            println!("{}", line);
            last_line = Some(line);
        }

        let status = child.wait().expect("Failed to wait on nix process");
        if !status.success() {
            eprintln!(
                "Nix run failed with exit code {}",
                status.code().unwrap_or(1)
            );
            exit(1);
        }

        self.result = last_line;
    }

    fn check_solution(&mut self) -> Option<bool> {
        let solutions_file_path = Path::new(&self.settings.problem_path).join("solutions.yml");
        self.solutions_data = if solutions_file_path.exists() {
            let file = fs::File::open(&solutions_file_path).expect("Failed to open solutions file");
            Some(serde_yaml::from_reader(file).expect("Failed to parse solutions file"))
        } else {
            return None;
        };

        let mapping;
        if &self.settings.example_name == "input" {
            mapping = self
                .solutions_data
                .as_mut()
                .unwrap()
                .as_mapping_mut()
                .expect("Expected solutions data to be a mapping")
                .entry(serde_yaml::Value::String("official".to_string()))
                .or_insert_with(|| Value::Mapping(Mapping::new()))
                .as_mapping_mut()
                .expect("Expected official solutions to be a mapping")
        } else {
            let examples = self
                .solutions_data
                .as_mut()
                .unwrap()
                .as_mapping_mut()
                .expect("Expected solutions data to be a mapping")
                .entry(Value::String("examples".to_string()))
                .or_insert_with(|| Value::Sequence(Sequence::new()))
                .as_sequence_mut()
                .expect("Expected examples to be a mapping");

            mapping = if let Some(example) = examples.iter_mut().find(|ex| {
                ex.as_mapping()
                    .and_then(|map| map.get(&Value::String("input".to_string())))
                    == Some(&Value::String(format!(
                        "{}.txt",
                        &self.settings.example_name
                    )))
            }) {
                example
                    .as_mapping_mut()
                    .expect("Expected example to be a mapping")
            } else {
                let new_example = Value::Mapping(Mapping::new());
                examples.push(new_example);
                examples
                    .last_mut()
                    .unwrap()
                    .as_mapping_mut()
                    .expect("Expected example to be a mapping")
            }
        };

        let expected_answer = mapping
            .get(&Value::String(format!("part{}", &self.settings.part)))
            .and_then(|v| v.as_str())
            .filter(|s| !s.is_empty());

        if expected_answer.is_none() {
            return None;
        }

        let result = if &self.settings.example_name == "input" {
            let answer_hash = format!("{:x}", md5::compute(self.result.as_ref().unwrap()));
            answer_hash == expected_answer.unwrap()
        } else {
            self.result.as_ref().unwrap() == expected_answer.unwrap()
        };

        if result {
            println!("\x1b[32m✅ Correct answer!\x1b[0m\n")
        } else if &self.settings.example_name == "input" {
            println!("\x1b[31m❌ Incorrect answer.\x1b[0m\n")
        } else {
            println!(
                "\x1b[31m❌ Incorrect answer. Expected {}\x1b[0m\n",
                expected_answer.unwrap()
            )
        }

        Some(result)
    }

    fn submit_solution(&mut self) -> bool {
        if &self.settings.example_name != "input" {
            return true;
        }
        let confirmation = self
            .settings
            .confirmation
            .unwrap_or_else(|| utils::confirm("Do you want to submit this answer?"));
        if !confirmation {
            return false;
        }

        let aoc_session = match env::var("AOC_SESSION") {
            Ok(session) => session,
            Err(_) => {
                eprintln!("AOC_SESSION environment variable not set");
                exit(1);
            }
        };

        let client = Client::new();
        let mut data = HashMap::new();
        data.insert("level", self.settings.part.to_string());
        data.insert("answer", self.result.as_ref().unwrap().to_string());

        let url = format!(
            "https://adventofcode.com/{}/day/{}/answer",
            &self.settings.year, &self.settings.day
        );
        let response = client
            .post(&url)
            .header("Cookie", format!("session={}", aoc_session))
            .form(&data)
            .send()
            .unwrap_or_else(|e| {
                eprintln!("Error submitting answer: {}", e);
                exit(1);
            });

        if !response.status().is_success() {
            eprintln!("Failed to submit answer: {}", response.status());
            exit(1);
        }

        let text = response.text().unwrap();
        if text.contains("That's the right answer!") {
            println!("\x1b[32m✅ Correct answer submitted!\x1b[0m");
            return true;
        }

        if text.contains("your answer is too high") {
            println!("\x1b[31m⬇️  Answer is too high.\x1b[0m");
        } else if text.contains("your answer is too low") {
            println!("\x1b[31m⬆️  Answer is too low.\x1b[0m");
        } else if text.contains("That's not the right answer") {
            println!("\x1b[31m❌ Incorrect answer submitted.\x1b[0m");
        } else if text.contains("You gave an answer too recently") {
            let re = Regex::new(r"You have ([^l]+) left to wait").unwrap();
            let wait = re
                .captures(&text)
                .and_then(|caps| caps.get(1).map(|m| m.as_str().trim().to_string()));
            println!(
                "\x1b[33m⏱ Please wait {} before submitting another answer.\x1b[0m",
                wait.unwrap_or("a while".to_string())
            );
        } else if text.contains("You don't seem to be solving the right level") {
            println!("\x1b[33m⚠️  You don't seem to be solving the right level.\x1b[0m");
        } else {
            println!("\x1b[33m⚠️  Unexpected response:\x1b[0m\n{}", text);
        }

        return false;
    }

    fn save_solution(&mut self) {
        let confirmation = self
            .settings
            .confirmation
            .unwrap_or_else(|| utils::confirm("Do you want to save this solution?"));
        if !confirmation {
            return;
        }

        crate::commands::save::run(
            Some(self.settings.example_name.clone()),
            Some(self.settings.part),
            self.result.as_ref().unwrap().to_string(),
        );
    }
}

fn verify_dockerfile(dockerfile: &Path, lang: &String) -> String {
    let content = fs::read_to_string(dockerfile).expect("Failed to read Dockerfile");
    let docker_tag = format!("aoc_{}:{:x}", lang, md5::compute(content));

    let output = Command::new("docker")
        .args(&["images", "-q", &docker_tag])
        .output()
        .expect("Failed to check Docker image");

    if output.stdout.is_empty() {
        println!("Dockerfile has changed or new build required. Building image...");
        let status = Command::new("docker")
            .args(&[
                "buildx",
                "build",
                "-t",
                &docker_tag,
                "-f",
                dockerfile.to_str().unwrap(),
                ".",
            ])
            .stdout(Stdio::inherit())
            .stderr(Stdio::inherit())
            .status()
            .expect("Failed to build Docker image");

        if !status.success() {
            eprintln!(
                "Docker build failed with exit code {}",
                status.code().unwrap()
            );
            exit(1);
        }
    }

    docker_tag
}

fn verify_docker_ref_file(docker_ref_file: &Path) -> String {
    let content = fs::read_to_string(docker_ref_file).expect("Failed to read Dockerfile");
    let docker_tag = content.trim_end().to_string();

    let output = Command::new("docker")
        .args(&["images", "-q", &docker_tag])
        .output()
        .expect("Failed to check Docker image");

    if output.stdout.is_empty() {
        println!("Docker image not found locally. Pulling from registry...");
        let status = Command::new("docker")
            .args(&["pull", &docker_tag])
            .stdout(Stdio::inherit())
            .stderr(Stdio::inherit())
            .status()
            .expect("Failed to pull Docker image");

        if !status.success() {
            eprintln!(
                "Docker pull failed with exit code {}",
                status.code().unwrap()
            );
            exit(1);
        }
    }

    docker_tag
}

fn create_docker_ref_file(docker_ref_file: &Path, lang: &String) -> String {
    println!("No cached image reference found. Pulling base image from registry...");
    let lang_config: LanguageConfig = utils::get_language_config(&lang).unwrap();
    let base_image = lang_config.container.unwrap();

    let status = Command::new("docker")
        .args(&["pull", &base_image])
        .stdout(Stdio::inherit())
        .stderr(Stdio::inherit())
        .status()
        .expect("Failed to pull Docker image");

    if !status.success() {
        eprintln!(
            "Docker pull failed with exit code {}",
            status.code().unwrap()
        );
        exit(1);
    }

    let output = Command::new("docker")
        .args(&[
            "inspect",
            "--format",
            "{{index .RepoDigests 0}}",
            &base_image,
        ])
        .output()
        .expect("Failed to check Docker image");

    let image_ref = String::from_utf8_lossy(&output.stdout).to_string();
    fs::write(docker_ref_file, &image_ref).expect("Failed to write Docker image reference");
    image_ref.trim_end().to_string()
}
