use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    if part == "1" {
        println!("{:?}", severity(&content, 0, false));
    } else {
        let mut offset = 0;
        while severity(&content, offset, true) != 0 { offset += 1; }
        println!("{:?}", offset);
    }
}

fn severity(content: &String, offset: u32, test_only: bool) -> u32 {
    let mut sum = 0;
    for line in content.lines() {
        let parts: Vec<&str> = line.split(": ").collect();
        let depth = parts[0].parse::<u32>().unwrap();
        let range = parts[1].parse::<u32>().unwrap();
        let cycle_time = 2 * (range - 2) + 2;

        if (depth + offset) % cycle_time == 0 {
            if test_only { return 1; }
            sum += depth * range;
        }
    }
    sum
}
