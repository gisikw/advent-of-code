use crossterm::event::{self, Event, KeyCode};
use crossterm::terminal::{disable_raw_mode, enable_raw_mode};
use rand::seq::SliceRandom;
use rand::thread_rng;
use std::collections::{HashMap, HashSet};
use std::fs;
use std::io::{self, Write};
use std::path::Path;
use std::path::PathBuf;

use toml::Value;

pub fn get_aoc_tempfile_path() -> PathBuf {
    PathBuf::from("/tmp/aoc_env")
}

pub fn get_supported_languages() -> Vec<String> {
    let config_path = Path::new("infra/languages.toml");
    let config_content = fs::read_to_string(config_path).unwrap();
    let parsed: Value = config_content.parse::<Value>().unwrap();

    parsed.as_table().unwrap().keys().cloned().collect()
}

pub fn resolve_aoc_settings(
    year: Option<usize>,
    day: Option<usize>,
    language: Option<String>,
) -> (usize, usize, String) {
    let mut resolved_year = year;
    let mut resolved_day = day;
    let mut resolved_lang = language;

    if resolved_year.is_none() || resolved_day.is_none() || resolved_lang.is_none() {
        if let Ok(env_content) = fs::read_to_string(get_aoc_tempfile_path()) {
            let env_map: HashMap<String, String> = env_content
                .lines()
                .filter_map(|line| {
                    let parts: Vec<&str> = line.split('=').collect();
                    if parts.len() == 2 {
                        Some((parts[0].to_string(), parts[1].to_string()))
                    } else {
                        None
                    }
                })
                .collect();

            if resolved_year.is_none() {
                resolved_year = env_map.get("export AOC_YEAR").and_then(|y| y.parse().ok());
            }

            if resolved_day.is_none() {
                resolved_day = env_map.get("export AOC_DAY").and_then(|d| d.parse().ok());
            }

            if resolved_lang.is_none() {
                resolved_lang = env_map.get("export AOC_LANG").cloned();
            }
        }
    }

    let supported_languages = get_supported_languages();

    if resolved_lang.is_none() {
        let mut rng = thread_rng();
        println!("No language set, choosing a random language from the supported list");
        resolved_lang = Some(supported_languages.choose(&mut rng).unwrap().to_string());
    }

    let y = resolved_year.unwrap_or_else(|| {
        eprintln!("Year must be set or provided");
        std::process::exit(1);
    });
    let d = resolved_day.unwrap_or_else(|| {
        eprintln!("Day must be set or provided");
        std::process::exit(1);
    });
    let l = resolved_lang.unwrap();

    if y < 2015 {
        eprintln!("Year must be 2015 or later.");
        std::process::exit(1);
    }

    if d < 1 || d > 25 {
        eprintln!("Day must be between 1 and 25.");
        std::process::exit(1);
    }

    if !supported_languages.contains(&l) {
        eprintln!("Unsupported language: {}", l);
        eprintln!("Supported languages: {}", supported_languages.join(", "));
        std::process::exit(1);
    }

    (y, d, l)
}

pub fn confirm(prompt: &str) -> bool {
    print!("{} [y/N]: ", prompt);
    io::stdout().flush().expect("Failed to flush stdout");

    enable_raw_mode().expect("Failed to enable raw mode");

    let mut result = false;
    if let Ok(Event::Key(key_event)) = event::read() {
        match key_event.code {
            KeyCode::Char('y') => result = true,
            _ => (),
        }
    }
    disable_raw_mode().expect("Failed to disable raw mode");
    println!();
    result
}

pub fn copy_dir_all(src: &Path, dst: &Path) -> io::Result<()> {
    fs::create_dir_all(dst)?;
    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let path = entry.path();
        let file_name = path.file_name().unwrap();
        let dst_path = dst.join(file_name);
        if path.is_dir() {
            copy_dir_all(&path, &dst_path)?;
        } else {
            fs::copy(&path, &dst_path)?;
        }
    }
    Ok(())
}

pub fn used_languages(year: &Option<usize>) -> Vec<String> {
    let mut all_languages = HashSet::new();
    match year {
        Some(year) => {
            let solutions_path = format!("./{}", year);
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
            if let Ok(entries) = fs::read_dir(".") {
                for entry in entries.flatten() {
                    let file_name = entry.file_name();
                    let file_name = file_name.to_string_lossy();

                    if entry.file_type().map(|ft| ft.is_dir()).unwrap_or(false)
                        && file_name.len() == 4
                        && file_name.chars().all(|c| c.is_ascii_digit())
                    {
                        let year_path = entry.path();
                        if let Ok(day_entries) = fs::read_dir(year_path) {
                            for day_entry in day_entries.flatten() {
                                if let Ok(day_type) = day_entry.file_type() {
                                    if day_type.is_dir() {
                                        let day_path = day_entry.path();
                                        let day_languages =
                                            get_language_directories(&day_path.to_string_lossy());
                                        all_languages.extend(day_languages);
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
