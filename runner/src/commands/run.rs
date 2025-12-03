use crate::store;
use crate::utils;
use regex::Regex;
use reqwest::blocking::Client;
use std::collections::HashMap;
use std::env;
use std::io::Read;
use std::process::{exit, Command, Stdio};
use std::sync::{Arc, atomic::{AtomicBool, Ordering}};

pub fn run(example_name: Option<String>, part: Option<usize>, confirmation: Option<bool>) {
    let mut context = RunContext::new(example_name, part, confirmation);

    context.execute_solution();

    // Skip all post-processing if flagged
    if context.skip_prompts {
        if context.result.is_none() {
            println!("\x1b[33m⏭ No output - skipping verification.\x1b[0m");
        } else {
            println!("\x1b[33m⏭ Skipping verification.\x1b[0m");
        }
        return;
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
    confirmation: Option<bool>,
}

struct RunContext {
    settings: Settings,
    result: Option<String>,
    skip_prompts: bool,
}

impl RunContext {
    fn new(example_name: Option<String>, part: Option<usize>, confirmation: Option<bool>) -> Self {
        let (year, day, lang) = utils::resolve_aoc_settings(None, None, None);
        RunContext {
            settings: Settings {
                year,
                day,
                language: lang.clone(),
                problem_path: format!("./{}/{:02}/inputs", year, day),
                solution_path: format!("./{}/{:02}/{}", year, day, lang),
                example_name: example_name.unwrap_or("input".to_string()),
                part: part.unwrap_or(1),
                confirmation,
            },
            result: None,
            skip_prompts: false,
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
            script -q -e -c "nix develop /infra#{lang} --command sh $run" /script_output
            "#,
            lang = self.settings.language,
            example = self.settings.example_name,
            part = self.settings.part,
        );
        let current_dir = env::current_dir().expect("Failed to get current dir");
        let infra_path = current_dir.join("infra");

        // Create temp file for script output
        let script_output = tempfile::NamedTempFile::new().expect("failed to create temp file");
        let script_output_path = script_output
            .path()
            .to_str()
            .expect("failed to generate temp path");

        // Generate a unique container name for cleanup
        let container_name = format!("aoc-run-{}", std::process::id());

        // Set up SIGINT handler to kill the container
        let container_name_clone = container_name.clone();
        let interrupted = Arc::new(AtomicBool::new(false));
        let interrupted_clone = interrupted.clone();
        ctrlc::set_handler(move || {
            interrupted_clone.store(true, Ordering::SeqCst);
            let _ = Command::new("docker")
                .args(&["kill", &container_name_clone])
                .stdout(Stdio::null())
                .stderr(Stdio::null())
                .status();
        }).expect("Failed to set Ctrl-C handler");

        let status = Command::new("docker")
            .args(&["run", "--rm", "-t"])
            .args(&["--name", &container_name])
            .args(&["--platform", "linux/amd64"])
            .args(&["-v", "aoc-nix:/nix"])
            .arg("-v")
            .arg(format!("{}:/infra/", infra_path.display()))
            .arg("-v")
            .arg(format!("{}:/problem", &self.settings.problem_path))
            .arg("-v")
            .arg(format!("{}:/code", &self.settings.solution_path))
            .arg("-v")
            .arg(format!("{}:/script_output", script_output_path))
            .arg("aoc-nix-image")
            .args(&["sh", "-c", &full_command])
            .status()
            .expect("Failed to execute Docker container");

        // If we were interrupted, exit cleanly
        if interrupted.load(Ordering::SeqCst) {
            eprintln!("\nInterrupted.");
            exit(130);
        }

        if !status.success() {
            eprintln!(
                "Docker run failed with exit code {}",
                status.code().unwrap_or(-1)
            );
            exit(1);
        }

        // Read full script output
        let mut script_file = script_output.into_file();
        let mut full_output = String::new();
        script_file
            .read_to_string(&mut full_output)
            .expect("Failed to read script output");

        // Check for skip directive
        if full_output.contains("!aoc skip") {
            self.skip_prompts = true;
        }

        // Strip ANSI escape sequences for answer extraction
        let ansi_regex = Regex::new(r"\x1b\[[0-9;]*[a-zA-Z]|\x1b\].*?\x07|\r").unwrap();
        let clean_output = ansi_regex.replace_all(&full_output, "");

        // Extract answer as last non-empty line, filtering out:
        // - empty lines
        // - script command metadata lines
        // - nix evaluating derivation lines
        let answer = clean_output
            .lines()
            .filter(|line| {
                let trimmed = line.trim();
                !trimmed.is_empty()
                    && !trimmed.starts_with("Script started on")
                    && !trimmed.starts_with("Script done on")
                    && !trimmed.starts_with("evaluating derivation")
            })
            .last()
            .map(|s| s.trim().to_string());

        match answer {
            Some(ans) => self.result = Some(ans),
            None => {
                // No non-empty lines - skip processing
                self.skip_prompts = true;
            }
        }
    }

    fn check_solution(&mut self) -> Option<bool> {
        let result = store::is_correct_answer(
            self.settings.year as u16,
            self.settings.day as u8,
            &self.settings.example_name,
            self.settings.part as u8,
            self.result.as_ref().unwrap(),
        )?;

        if result {
            println!("\x1b[32m✅ Correct answer!\x1b[0m\n")
        } else {
            println!("\x1b[31m❌ Incorrect answer.\x1b[0m\n")
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
