use crate::utils;
use std::collections::HashSet;
use std::fs;

pub fn run(year: &Option<usize>) {
    let languages = utils::get_supported_languages();
    let used_languages = find_used_languages(year);
    let mut used_languages = languages
        .iter()
        .filter(|language| used_languages.contains(language))
        .cloned()
        .collect::<Vec<String>>();

    if used_languages.is_empty() {
        match year {
            Some(year) => println!("No unused languages found for year {}", year),
            None => println!("No unused languages found"),
        }
    } else {
        used_languages.sort();
        match year {
            Some(year) => println!(
                "Used languages for year {} ({}): {}",
                year,
                used_languages.len(),
                used_languages.join(", ")
            ),
            None => println!(
                "Used languages ({}): {}",
                used_languages.len(),
                used_languages.join(", ")
            ),
        }
    }
}

fn find_used_languages(year: &Option<usize>) -> Vec<String> {
    let mut all_languages = HashSet::new();
    match year {
        Some(year) => {
            let solutions_path = format!("./solutions/{}", year);
            if let Ok(day_entries) = fs::read_dir(&solutions_path) {
                for day_entry in day_entries.flatten() {
                    if let Ok(day_type) = day_entry.file_type() {
                        if day_type.is_dir() {
                            let day_path = day_entry.path();
                            let day_languages =
                                get_language_directories(&day_path.to_str().unwrap());
                            all_languages.extend(day_languages);
                        }
                    }
                }
            }
        }
        None => {
            if let Ok(year_entries) = fs::read_dir("./solutions") {
                for year_entry in year_entries.flatten() {
                    if let Ok(file_type) = year_entry.file_type() {
                        if file_type.is_dir() {
                            let year_path = year_entry.path();
                            if let Ok(day_entries) = fs::read_dir(year_path) {
                                for day_entry in day_entries.flatten() {
                                    if let Ok(day_type) = day_entry.file_type() {
                                        if day_type.is_dir() {
                                            let day_path = day_entry.path();
                                            let day_languages = get_language_directories(
                                                &day_path.to_str().unwrap(),
                                            );
                                            all_languages.extend(day_languages);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    };
    all_languages.into_iter().collect()
}

fn get_language_directories(path: &str) -> HashSet<String> {
    let mut languages = HashSet::new();
    if let Ok(entries) = fs::read_dir(path) {
        for entry in entries.flatten() {
            if let Ok(file_type) = entry.file_type() {
                if file_type.is_dir() {
                    if let Some(lang) = entry.file_name().to_str() {
                        languages.insert(lang.to_string());
                    }
                }
            }
        }
    }
    languages
}
