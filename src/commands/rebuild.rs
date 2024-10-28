use std::process::{Command, exit};

pub fn run() {
    println!("Rebuilding the aoc binary...");

    let status = Command::new("cargo")
        .arg("build")
        .arg("--release")
        .status();

    match status {
        Ok(status) if status.success() => {
            let copy_status = Command::new("cp")
                .arg("target/release/aoc")
                .arg("./aoc")
                .status();

            match copy_status {
                Ok(copy_status) if copy_status.success() => {
                    println!("aoc binary rebuilt successfully.");
                },
                Ok(copy_status) => {
                    eprintln!("Failed to copy aoc binary: {}", copy_status);
                    exit(copy_status.code().unwrap_or(1));
                },
                Err(e) => {
                    eprintln!("Failed to execute command: {}", e);
                    exit(1);
                }
            }
        },
        Ok(status) => {
            eprintln!("Command failed with exit code: {}", status);
            exit(status.code().unwrap_or(1));
        },
        Err(e) => {
            eprintln!("Failed to execute cargo build: {}", e);
            exit(1);
        },
    }
}
