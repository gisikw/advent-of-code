use std::process::{exit, Command};

pub fn run() {
    println!("Rebuilding the aoc binary...");

    let status = Command::new("cargo")
        .arg("build")
        .arg("--release")
        .current_dir("runner")
        .status();

    match status {
        Ok(status) if status.success() => {
            let copy_status = std::fs::copy("runner/target/release/aoc", "aoc");
            match copy_status {
                Ok(_) => {
                    println!("aoc binary rebuilt successfully.");
                }
                Err(e) => {
                    eprintln!("Failed to execute command: {}", e);
                    exit(1);
                }
            }
        }
        Ok(status) => {
            eprintln!("Command failed with exit code: {}", status);
            exit(status.code().unwrap_or(1));
        }
        Err(e) => {
            eprintln!("Failed to execute cargo build: {}", e);
            exit(1);
        }
    }
}
