use std::process::{exit, Command};

pub fn run(language: &Option<String>) {
    let status = Command::new("cargo")
        .arg("test")
        .args(language.as_ref().map(|l| format!("language_test_{}", l)))
        .args(["--", "--test-threads=1"])
        .current_dir("runner")
        .status()
        .expect("Failed to run cargo test");

    exit(status.code().unwrap_or(1));
}
