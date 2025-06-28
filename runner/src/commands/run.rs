use crate::utils::{self};
use md5;
use regex::Regex;
use reqwest::blocking::Client;
use serde_yaml::{Mapping, Sequence, Value};
use std::collections::HashMap;
use std::env;
use std::fs;
use std::io::Read;
use std::path::Path;
use std::process::{exit, Command};

pub fn run(example_name: Option<String>, part: Option<usize>, confirmation: Option<bool>) {
    let mut context = RunContext::new(example_name, part, confirmation);

    context.execute_solution();
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
    confirmation: Option<bool>,
}

struct RunContext {
    settings: Settings,
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
                example_name: example_name.unwrap_or("input".to_string()),
                part: part.unwrap_or(1),
                confirmation,
            },
            result: None,
            solutions_data: None,
        }
    }

    fn execute_solution(&mut self) {
        let full_command = format!(
            r#"
            run=$(mktemp)
            echo 'set -euo pipefail' > "$run"
            echo 'printf "\033[F\n"' >> "$run"
            echo 'input_file=/problem/{example}.txt' >> "$run"
            echo 'part={part}' >> "$run"
            nix eval --raw /infra#langMeta.x86_64-linux.{lang}.run >> "$run"
            script -q -e -c "nix develop /infra#{lang} --command sh $run" /script;
            tail -n 3 /script | head -n 1 > /out
            "#,
            lang = self.settings.language,
            example = self.settings.example_name,
            part = self.settings.part,
        );
        let current_dir = env::current_dir().expect("Failed to get current dir");
        let infra_path = current_dir.join("infra");

        let output = tempfile::NamedTempFile::new().expect("failed to create temp file");
        let out_path = output
            .path()
            .to_str()
            .expect("failed to generate temp path");

        let status = Command::new("docker")
            .args(&["run", "--rm", "-t"])
            .args(&["--platform", "linux/amd64"])
            .args(&["-v", "aoc-nix:/nix"])
            .arg("-v")
            .arg(format!("{}:/infra/", infra_path.display()))
            .arg("-v")
            .arg(format!("{}:/problem", &self.settings.problem_path))
            .arg("-v")
            .arg(format!("{}:/code", &self.settings.solution_path))
            .arg("-v")
            .arg(format!("{}:/out", out_path))
            .arg("aoc-nix-image")
            .args(&["sh", "-c", &full_command])
            .status()
            .expect("Failed to execute Docker container");

        if !status.success() {
            eprintln!(
                "Docker run failed with exit code {}",
                status.code().unwrap()
            );
            exit(1);
        }

        let mut output_file = output.into_file();
        let mut answer = String::new();
        output_file
            .read_to_string(&mut answer)
            .expect("Failed to read answer from output file");

        let answer = answer.trim_end();
        self.result = Some(answer.to_string());
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
