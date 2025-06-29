use crate::utils;

pub fn run(year: &Option<usize>) {
    let languages = utils::get_supported_languages();
    let used_languages = utils::used_languages(year);
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
