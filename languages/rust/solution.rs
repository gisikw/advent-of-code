use std::fs;

fn main() {
    let args: Vec<String> = std::env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file).expect("Failed to read input file");
    let lines_count = content.lines().count();

    println!("Received {} lines of input for part {}", lines_count, part);
}
