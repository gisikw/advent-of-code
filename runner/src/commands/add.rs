use crate::store;
use crate::utils;
use std::fs;
use std::path::Path;
use std::process::exit;

pub fn run(example_name: &str, part1_answer: &Option<String>, part2_answer: &Option<String>) {
    let (resolved_year, resolved_day, _) = utils::resolve_aoc_settings(None, None, None);

    if example_name.is_empty() {
        eprintln!("No example name provided");
        exit(1);
    }

    let inputs_dir = format!("./{}/{:02}/inputs", resolved_year, resolved_day);
    let example_file_path = Path::new(&inputs_dir).join(format!("{}.txt", example_name));

    fs::create_dir_all(&inputs_dir).expect("Failed to create inputs directory");
    if !example_file_path.exists() {
        fs::write(&example_file_path, "").expect("Failed to create example file");
    }

    if let Some(answer) = part1_answer {
        store::save_answer(
            resolved_year as u16,
            resolved_day as u8,
            example_name,
            1,
            answer,
        );
    }

    if let Some(answer) = part2_answer {
        store::save_answer(
            resolved_year as u16,
            resolved_day as u8,
            example_name,
            2,
            answer,
        );
    }
}
