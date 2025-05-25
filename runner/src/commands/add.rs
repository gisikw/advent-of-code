use crate::utils;
use serde_yaml::{Value, Mapping, Sequence};
use std::process::exit;
use std::path::Path;
use std::fs;

pub fn run(example_name: &str, part1_answer: &Option<String>, part2_answer: &Option<String>) {
    let (resolved_year, resolved_day, _) = utils::resolve_aoc_settings(None, None, None);

    if example_name.is_empty() {
        eprintln!("No example name provided");
        exit(1);
    }

    let problem_dir = format!("./problems/{}/{:02}", resolved_year, resolved_day);
    let solutions_file_path = Path::new(&problem_dir).join("solutions.yml");
    let example_file_path = Path::new(&problem_dir).join(format!("{}.txt", example_name));

    fs::create_dir_all(&problem_dir).expect("Failed to create problem directory");

    let mut solutions_data = if solutions_file_path.exists() {
        let file = fs::File::open(&solutions_file_path).expect("Failed to open solutions file");
        serde_yaml::from_reader(file).expect("Failed to parse solutions file")
    } else {
        Value::Mapping(Mapping::new())
    };

    let examples = solutions_data
        .as_mapping_mut()
        .expect("Expected solutions.yml to be a mapping")
        .entry(Value::String("examples".to_string()))
        .or_insert_with(|| Value::Sequence(Sequence::new()))
        .as_sequence_mut()
        .expect("Expected examples to be a sequence");

    if examples.iter().any(|ex| {
        ex.as_mapping()
            .and_then(|map| map.get(&Value::String("input".to_string())))
            == Some(&Value::String(format!("{}.txt", example_name)))
    }) {
        eprintln!("Error: An example with the name '{}' already exists", example_name);
        exit(1);
    }

    let mut new_example = Mapping::new();
    new_example.insert(Value::String("input".to_string()), Value::String(format!("{}.txt", example_name)));
    new_example.insert(Value::String("part1".to_string()), Value::String(part1_answer.clone().unwrap_or("".to_string()).to_owned()));
    new_example.insert(Value::String("part2".to_string()), Value::String(part2_answer.clone().unwrap_or("".to_string()).to_owned()));
    examples.push(Value::Mapping(new_example));

    let yaml_data = serde_yaml::to_string(&solutions_data).expect("Failed to serialize solutions data");
    fs::write(&solutions_file_path, yaml_data).expect("Failed to write solutions file");

    if !example_file_path.exists() {
        fs::write(&example_file_path, "").expect("Failed to create example file");
    }
}
