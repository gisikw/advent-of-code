use std::process::exit;
use std::io::{self, Write};
use crate::utils;

pub fn run(year: usize, day: usize, language: &Option<String>) {
    let results = utils::resolve_aoc_settings(Some(year), Some(day), language.clone());
    let (resolved_year, resolved_day, resolved_lang) = results;

    let content = format!(
        "export AOC_YEAR={}\nexport AOC_DAY={:02}\nexport AOC_LANG={}\n",
        resolved_year, resolved_day, resolved_lang
    );

    let path = utils::get_aoc_tempfile_path();
    if let Err(e) = write_to_file(&path, &content) {
        eprintln!("Failed to set configuration: {}", e);
        exit(1);
    } else {
        println!(
            "Configuration set for year {}, day {:02}, language {}", 
            resolved_year, resolved_day, resolved_lang
        );
    }
}

fn write_to_file(path: &std::path::PathBuf, content: &str) -> io::Result<()> {
    let mut file = std::fs::File::create(path)?;
    file.write_all(content.as_bytes())
}
