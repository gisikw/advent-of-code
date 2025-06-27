use anyhow::{Context, Result};
use std::fs;
use std::process::{exit, Command};

pub fn run() {
    if let Err(e) = try_run() {
        eprintln!("Build error: {}", e);
        exit(1);
    }
}

fn try_run() -> Result<()> {
    println!("Rebuilding the aoc binary and execution container");

    Command::new("cargo")
        .arg("build")
        .arg("--release")
        .current_dir("runner")
        .status()?
        .success()
        .then_some(())
        .context("Cargo build failed")?;

    fs::copy("runner/target/release/aoc", "aoc").context("Failed to copy aoc binary")?;

    Command::new("docker")
        .args(&["volume", "rm", "aoc-nix", "-f"])
        .status()?
        .success()
        .then_some(())
        .context("Docker volume removal failed")?;

    Command::new("docker")
        .args(&[
            "build",
            "--platform",
            "linux/amd64",
            "-t",
            "aoc-nix-image",
            "./infra",
        ])
        .status()?
        .success()
        .then_some(())
        .context("Docker build failed")?;

    println!("aoc binary rebuilt and Docker image refreshed.");
    Ok(())
}
