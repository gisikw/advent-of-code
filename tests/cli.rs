use std::process::Command;
use std::fs;

struct Cleanup;

impl Drop for Cleanup {
    fn drop(&mut self) {
        fs::remove_dir_all("./problems/9999").expect("Failed to remove problem directory");
        fs::remove_dir_all("./solutions/9999").expect("Failed to remove solution directory");
    }
}

fn execute_language_template(lang: &str) {
    let _cleanup = Cleanup;

    let output = Command::new("./target/debug/aoc")
        .args(["new", "9999", "25", lang, "-y"])
        .output()
        .expect("Failed to execute `aoc new` command");

    assert!(
        output.status.success(),
        "Command failed for language {}: {:?}",
        lang,
        output
    );

    fs::create_dir_all("./problems/9999/25").expect("Failed to create problem directory");
    let input_file = "./problems/9999/25/input.txt";
    let text = concat!(
        "line 1\n",
        "line 2\n",
        "line 3\n",
    );
    fs::write(input_file, text).expect("Failed to write input file");

    let output = Command::new("./target/debug/aoc")
        .args(["run", "2", "-n"])
        .output()
        .expect("Failed to execute `aoc run` command");

    let stdout = String::from_utf8_lossy(&output.stdout);
    assert!(
        stdout.contains("Received 3 lines of input for part 2"),
        "Unexpected output for language {}: {}",
        lang,
        stdout
    );
}

include!(concat!(env!("OUT_DIR"), "/language_tests.rs"));
