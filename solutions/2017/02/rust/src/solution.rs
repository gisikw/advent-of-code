use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let closure = match part.as_str() {
        "1" => {
            |line: &str| {
                let nums: Vec<u32> = line
                    .split("\t")
                    .map(|n| n.parse::<u32>().unwrap())
                    .collect();
                nums.iter().max().unwrap() - nums.iter().min().unwrap()
            }
        }
        _ => {
            |line: &str| {
                let nums: Vec<u32> = line
                    .split("\t")
                    .map(|n| n.parse::<u32>().unwrap())
                    .collect();

                nums.iter().enumerate().find_map(|(i, n)| {
                    nums.iter().enumerate().find_map(|(j, m)| {
                        if i != j && n % m == 0 {
                            Some(n / m)
                        } else {
                            None
                        }
                    })
                }).unwrap()
            }
        }
    };

    let sum: u32 = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file")
        .lines()
        .map(closure)
        .sum();

    println!("{}", sum);
}
