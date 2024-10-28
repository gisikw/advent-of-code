use std::fs;
use std::io::ErrorKind;
use crate::utils::get_aoc_tempfile_path;

pub fn run() {
    let path = get_aoc_tempfile_path();
    match fs::remove_file(&path) {
        Ok(_) => println!("Configuration cleared successfully."),
        Err(e) if e.kind() == ErrorKind::NotFound => {
            // If the file doesn't exist, we don't need to do anything
        },
        Err(e) => eprintln!("Failed to clear configuration: {}", e),
    }
}
