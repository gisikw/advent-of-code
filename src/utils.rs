use serde::Deserialize;
use std::path::PathBuf;
use std::fs;
use std::path::Path;
use std::collections::HashMap;

#[derive(Debug, Deserialize)]
struct Config {
    languages: HashMap<String, LanguageConfig>,
}

#[derive(Debug, Deserialize)]
struct LanguageConfig {
    container: Option<String>,
    run: String,
}

pub fn get_aoc_tempfile_path() -> PathBuf {
    PathBuf::from("/tmp/aoc_env")
}

pub fn get_supported_languages() -> Vec<String> {
    let config_path = Path::new("config.yml");
    let config_content = fs::read_to_string(config_path).unwrap();
    let config: Config = serde_yaml::from_str(&config_content).unwrap();

    config.languages.keys().cloned().collect::<Vec<String>>()
}
