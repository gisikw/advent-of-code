use std::process::{Command, exit};

pub fn run(command: &str, args: &[String]) {
    let script_path = format!("./lib/{}.sh", command);
    let common_script_path = "lib/_common.sh";
    let bash_command = format!(
        r#"
        export AOC_TEMPFILE=/tmp/aoc_env
        local_path=$(pwd)
        dependencies=("docker" "curl" "yq")
        missing_deps=()
        for dep in "${{dependencies[@]}}"; do
          if ! which "$dep" &> /dev/null; then
            missing_deps+=("$dep")
          fi
        done
        if [[ ${{#missing_deps[@]}} -gt 0 ]]; then
          echo "The following dependencies are missing:"
          for dep in "${{missing_deps[@]}}"; do
            echo "- $dep"
          done
          echo "Please install the missing dependencies and try again."
          exit 1
        fi
        source {common_script_path}
        source {script_path}
        main "$@"
        "#,
        common_script_path = common_script_path,
        script_path = script_path
    );

    let status = Command::new("bash")
        .arg("-c")
        .arg(bash_command)
        .arg("")
        .args(args)
        .status();

    match status {
        Ok(status) if status.success() => (),
        Ok(status) => {
            eprintln!("Command failed with exit code: {}", status);
            exit(status.code().unwrap_or(1));
        },
        Err(e) => {
            eprintln!("Failed to execute command: {}", e);
            exit(1);
        }
    }
}
