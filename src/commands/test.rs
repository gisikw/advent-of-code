use std::process::{Command, exit};

pub fn run(language: &Option<String>) {
    let status = Command::new("cargo")
        .arg("test")
        .args(language.as_ref().map(|l| format!("language_test_{}", l)))
        .status()
        .expect("Failed to run cargo test");

    exit(status.code().unwrap_or(1));
}
