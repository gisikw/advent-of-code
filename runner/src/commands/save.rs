use crate::store;
use crate::utils;

pub fn run(example_name: Option<String>, part: Option<usize>, answer: String) {
    let (resolved_year, resolved_day, _) = utils::resolve_aoc_settings(None, None, None);
    let resolved_part = part.unwrap_or(1);

    let solution_type = match example_name.as_deref() {
        Some("input") | None => "Official",
        _ => "Example",
    };

    store::save_answer(
        resolved_year as u16,
        resolved_day as u8,
        &example_name.unwrap_or("input".to_string()),
        resolved_part as u8,
        &answer,
    );

    println!("{} solution saved", solution_type);
}
