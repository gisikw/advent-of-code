use std::process::exit;
use rand::seq::SliceRandom;
use rand::thread_rng;
use std::io::{self, Write};
use crate::utils;

pub fn run(year: usize, day: usize, language: &Option<String>) {
    if year < 2015 {
        eprintln!("Year must be 2015 or later.");
        exit(1);
    }

    if day < 1 || day > 25 {
        eprintln!("Day must be between 1 and 25.");
        exit(1);
    }

    let supported_languages = utils::get_supported_languages();
    let selected_lang = match language {
        Some(lang) => lang.clone(),
        None => {
            let mut rng = thread_rng();
            let lang = supported_languages.choose(&mut rng).unwrap();
            lang.to_string()
        }
    };

    if !supported_languages.contains(&selected_lang) {
        eprintln!("Unsupported language: {}", selected_lang);
        eprintln!("Supported languages: {}", supported_languages.join(", "));
        exit(1);
    }

    let content = format!(
        "export AOY_YEAR={}\nexport AOC_DAY={:02}\nexport AOC_LANG={}\n",
        year, day, selected_lang
    );

    let path = utils::get_aoc_tempfile_path();
    if let Err(e) = write_to_file(&path, &content) {
        eprintln!("Failed to set configuration: {}", e);
        exit(1);
    } else {
        println!(
            "Configuration set for year {}, day {:02}, language {}", 
            year, day, selected_lang
        );
    }
}

fn write_to_file(path: &std::path::PathBuf, content: &str) -> io::Result<()> {
    let mut file = std::fs::File::create(path)?;
    file.write_all(content.as_bytes())
}
