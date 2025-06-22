use anyhow::{anyhow, Result};
use std::fs;
use std::io::Write;
use std::path;
use std::process::{exit, Command, Stdio};
use tempfile;

struct Worktree {
    tempdir: tempfile::TempDir,
}

impl Worktree {
    pub fn new() -> Result<Self> {
        let tempdir = tempfile::tempdir()?;
        let instance = Self { tempdir };
        instance.prepare()?;
        Ok(instance)
    }

    pub fn prepare(&self) -> Result<()> {
        let path = self.path();

        let add = Command::new("git")
            .arg("worktree")
            .arg("add")
            .arg("--detach")
            .arg(path)
            .stdout(Stdio::null())
            .stderr(Stdio::null())
            .status()?;

        if !add.success() {
            return Err(anyhow!("git worktree add failed: {:?}", add));
        }

        let modified_unstaged = Command::new("git").args(&["ls-files", "-m"]).output()?;

        let modified_staged = Command::new("git")
            .args(&["diff", "--name-only", "--cached"])
            .output()?;

        let untracked = Command::new("git")
            .arg("ls-files")
            .arg("--others")
            .arg("--exclude-standard")
            .output()?;

        let files = [
            String::from_utf8(modified_unstaged.stdout)?,
            String::from_utf8(modified_staged.stdout)?,
            String::from_utf8(untracked.stdout)?,
        ]
        .join("\n");

        for line in files.lines().filter(|line| !line.trim().is_empty()) {
            let src = path::Path::new(line);
            let dest = self.path().join(line);

            if let Some(parent) = dest.parent() {
                fs::create_dir_all(parent)?;
            }

            fs::copy(src, &dest)?;
        }

        Ok(())
    }

    pub fn path(&self) -> &path::Path {
        self.tempdir.path()
    }
}

impl Drop for Worktree {
    fn drop(&mut self) {
        let _ = Command::new("git")
            .arg("worktree")
            .arg("remove")
            .arg("-f")
            .arg(self.path())
            .status();
    }
}

pub fn run(language: &Option<String>) {
    let result = match language {
        Some(lang) => test_language(lang),
        _ => Err(anyhow!("Testing all languages not yet supported")),
    };

    exit(if result.is_ok() { 0 } else { 1 })
}

fn test_language(lang: &str) -> Result<()> {
    let worktree = Worktree::new()?;
    create_and_run_example(lang, &worktree)
}

fn create_and_run_example(lang: &str, worktree: &Worktree) -> Result<()> {
    let status = Command::new("./aoc")
        .arg("new")
        .arg("9999")
        .arg("25")
        .arg(lang)
        .arg("-y")
        .current_dir(&worktree.path())
        .stdout(Stdio::null())
        .status()?;

    if !status.success() {
        return Err(anyhow!("aoc new failed for {lang}"));
    }

    let input_path = worktree.path().join("problems/9999/25/input.txt");
    fs::create_dir_all(input_path.parent().unwrap())?;
    let mut f = fs::File::create(input_path)?;
    writeln!(f, "line 1\nline 2\nline 3")?;

    let output = Command::new("./aoc")
        .arg("run")
        .current_dir(&worktree.path())
        .output()?;

    let stdout = String::from_utf8_lossy(&output.stdout);
    let passed = stdout
        .trim()
        .contains("Received 3 lines of input for part 1");

    println!("{}", stdout);

    if passed {
        println!("\x1b[32m✅ {}\x1b[0m", lang);
        Ok(())
    } else {
        eprintln!("\x1b[31m❌ {}\x1b[0m", lang);
        eprintln!("Expected output not found:\n{}", stdout);
        Err(anyhow!("Failed for language {}", lang))
    }
}
