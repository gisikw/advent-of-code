use crate::utils;
use md5;
use serde_yaml::{Mapping, Sequence, Value};
use std::fs;
use std::path::Path;

pub fn run(example_name: Option<String>, part: Option<usize>, answer: String) {
    let (resolved_year, resolved_day, _) = utils::resolve_aoc_settings(None, None, None);
    let resolved_part = part.unwrap_or(1);

    let problem_dir = format!("./problems/{}/{:02}", resolved_year, resolved_day);
    let solutions_file_path = Path::new(&problem_dir).join("solutions.yml");

    let mut solutions_data = if solutions_file_path.exists() {
        let file = fs::File::open(&solutions_file_path).expect("Failed to open solutions file");
        serde_yaml::from_reader(file).expect("Failed to parse solutions file")
    } else {
        Value::Mapping(Mapping::new())
    };

    match example_name.as_deref() {
        Some("input.txt") | None => {
            add_official_answer(&mut solutions_data, resolved_part, &answer);
            println!("Official solution saved.");
        }
        _ => {
            add_example_answer(
                &mut solutions_data,
                &example_name.unwrap(),
                resolved_part,
                &answer,
            );
            println!("Example answer saved.");
        }
    }

    let yaml_data =
        serde_yaml::to_string(&solutions_data).expect("Failed to serialize solutions data");
    fs::write(&solutions_file_path, yaml_data).expect("Failed to write solutions file");
}

fn add_official_answer(solutions_data: &mut Value, part: usize, answer: &str) {
    let answer_hash = format!("{:x}", md5::compute(answer));

    let official_mapping = solutions_data
        .as_mapping_mut()
        .expect("Expected solutions data to be a mapping")
        .entry(Value::String("official".to_string()))
        .or_insert_with(|| Value::Mapping(Mapping::new()))
        .as_mapping_mut()
        .expect("Expected official solutions to be a mapping");

    official_mapping.insert(
        Value::String(format!("part{}", part)),
        Value::String(answer_hash),
    );
}

fn add_example_answer(solutions_data: &mut Value, example_name: &str, part: usize, answer: &str) {
    let examples = solutions_data
        .as_mapping_mut()
        .expect("Expected solutions data to be a mapping")
        .entry(Value::String("examples".to_string()))
        .or_insert_with(|| Value::Sequence(Sequence::new()))
        .as_sequence_mut()
        .expect("Expected examples to be a mapping");

    if let Some(example) = examples.iter_mut().find(|ex| {
        ex.as_mapping()
            .and_then(|map| map.get(&Value::String("input".to_string())))
            == Some(&Value::String(format!("{}.txt", example_name)))
    }) {
        example
            .as_mapping_mut()
            .expect("Expected example to be a mapping")
            .insert(
                Value::String(format!("part{}", part)),
                Value::String(answer.to_string()),
            );
    } else {
        let mut new_example = Mapping::new();
        new_example.insert(
            Value::String("input".to_string()),
            Value::String(format!("{}.txt", example_name)),
        );
        new_example.insert(
            Value::String(format!("part{}", part)),
            Value::String(answer.to_string()),
        );
        examples.push(Value::Mapping(new_example));
    }
}
