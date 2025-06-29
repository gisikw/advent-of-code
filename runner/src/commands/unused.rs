use crate::utils;

pub fn run(year: &Option<usize>) {
    let languages = utils::get_supported_languages();
    let used_languages = utils::used_languages(year);
    let mut unused_languages = languages
        .iter()
        .filter(|language| !used_languages.contains(language))
        .cloned()
        .collect::<Vec<String>>();

    if unused_languages.is_empty() {
        match year {
            Some(year) => println!("No unused languages found for year {}", year),
            None => println!("No unused languages found"),
        }
    } else {
        unused_languages.sort();
        match year {
            Some(year) => println!(
                "Unused languages for year {} ({}): {}",
                year,
                unused_languages.len(),
                unused_languages.join(", ")
            ),
            None => println!(
                "Unused languages ({}): {}",
                unused_languages.len(),
                unused_languages.join(", ")
            ),
        }
    }
}
