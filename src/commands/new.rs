use crate::utils;
use crate::commands;
use std::fs;
use std::path::Path;

pub fn run(year: usize, day: usize, language: &Option<String>, yes: &bool) {
    commands::set::run(year, day, language);

    let results = utils::resolve_aoc_settings(Some(year), Some(day), language.clone());
    let (resolved_year, resolved_day, resolved_lang) = results;

    let create_message = format!(
        "Create new solution in ./solutions/{}/{:02}/{}?",
        resolved_year, resolved_day, resolved_lang
    );
    if !utils::confirm(&create_message) && !yes {
        println!("Aborted");
        return;
    }

    let solution_dir = format!("./solutions/{}/{:02}", resolved_year, resolved_day);
    let template_path = format!("./languages/{}", resolved_lang);
    let target_path = format!("{}/{}", solution_dir, resolved_lang);

    fs::create_dir_all(&solution_dir).expect("Failed to create solution directory");
    utils::copy_dir_all(&Path::new(&template_path), &Path::new(&target_path)).expect("Failed to copy template to solution directory");

    let fetch_message = "Solution created. Would you like to fetch the input?";
    if utils::confirm(&fetch_message) && !yes {
        commands::fetch::run(&Some(resolved_year), &Some(resolved_day));
    }
}
