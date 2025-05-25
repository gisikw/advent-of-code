use serde_yaml::Value;
use std::fs;
use std::io::Write;
use std::path::Path;

fn main() {
    println!("cargo:rerun-if-changed=config.yml");

    let config_path = Path::new("../config.yml");
    let out_dir = std::env::var("OUT_DIR").expect("OUT_DIR not set");
    let dest_path = Path::new(&out_dir).join("language_tests.rs");

    // Read and parse `config.yml`
    let config_content = fs::read_to_string(config_path).expect("Failed to read config.yml");
    let config: Value = serde_yaml::from_str(&config_content).expect("Failed to parse config.yml");

    let languages = config
        .get("languages")
        .expect("Missing 'languages' key in config.yml")
        .as_mapping()
        .expect("'languages' should be a mapping")
        .keys()
        .map(|k| {
            k.as_str()
                .expect("Language keys should be strings")
                .to_string()
        })
        .collect::<Vec<String>>();

    // Generate language tests in `language_tests.rs`
    let mut file = fs::File::create(dest_path).expect("Failed to create language_tests.rs");
    for lang in languages {
        writeln!(
            file,
            "#[test]\nfn language_test_{}() {{ execute_language_template(\"{}\"); }}",
            lang, lang
        )
        .unwrap();
    }
}
