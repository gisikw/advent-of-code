use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let valid: usize = content
        .lines()
        .filter(|line| {
            let mut words: Vec<String> = if part == "1" {
                line.split(" ").map(|s| s.to_string()).collect()
            } else {
                line.split(" ").map(|word| {
                    let mut chars: Vec<char> = word.chars().collect();
                    chars.sort();
                    chars.iter().collect()
                }).collect()
            };
            let len = words.len();
            words.sort();
            words.dedup();
            words.len() == len
        }).count();

    println!("{}", valid);
}
