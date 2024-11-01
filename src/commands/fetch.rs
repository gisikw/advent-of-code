use std::env;
use crate::utils;
use std::fs;
use reqwest::blocking;
use std::process::exit;

pub fn run(year: &Option<usize>, day: &Option<usize>) {
    let results = utils::resolve_aoc_settings(year.clone(), day.clone(), None);
    let (resolved_year, resolved_day, _) = results;

    if resolved_year == 9999 {
        return
    }

    let url = format!("https://adventofcode.com/{}/day/{}/input", resolved_year, resolved_day);

    let aoc_session = match env::var("AOC_SESSION") {
        Ok(session) => session,
        Err(_) => {
            eprintln!("AOC_SESSION environment variable not set");
            exit(1);
        }
    };

    let client = blocking::Client::new();
    let response = client
        .get(&url)
        .header("Cookie", format!("session={}", aoc_session))
        .send();
    
    match response {
        Ok(resp) if resp.status().is_success() => {
            let problem_dir = format!("./problems/{}/{:02}", resolved_year, resolved_day);
            fs::create_dir_all(&problem_dir).expect("Failed to create problem directory");
            let output_file = format!("{}/input.txt", problem_dir);
            let content = resp.text().expect("Failed to read response body");
            fs::write(&output_file, content).expect("Failed to write input file");
            println!("Input fetched successfully for year {}, day {}", resolved_year, resolved_day);
        }
        Ok(resp) => {
            eprintln!("Failed to fetch input: {}", resp.status());
            exit(1);
        }
        Err(e) => {
            eprintln!("Error: Failed to send request: {}", e);
            exit(1);
        }
    }
}
