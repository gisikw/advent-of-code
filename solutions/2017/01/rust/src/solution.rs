use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let string = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file")
        .trim_end()
        .to_string();

    let sum: u32;
    match part.as_str() {
        "1" => {
            sum = string
                .chars()
                .fold((0, string.chars().last().unwrap()), |(acc, prev), curr|
                      if curr == prev {
                        (acc + curr.to_digit(10).unwrap(), curr)
                      } else {
                        (acc, curr)
                      }).0;
        }
        _ => {
            let len = string.len();
            let half = len / 2;
            sum = string
                .chars()
                .enumerate()
                .filter_map(|(i, c)| {
                    if c == string.chars().nth((i + half) % len).unwrap() {
                        c.to_digit(10)
                    } else {
                        None
                    }
                })
                .sum();
        }
    }
    println!("{}", sum);
}
