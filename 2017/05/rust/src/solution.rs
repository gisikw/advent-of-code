use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let mut instructions: Vec<i32> = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file")
        .lines().map(|line| line.parse::<i32>().unwrap()).collect();

    let mut pc: i32 = 0;
    let mut steps: u32 = 0;

    while pc >= 0 && pc < instructions.len() as i32 {
        let inst = instructions[pc as usize];
        if part == "2" && inst >= 3 {
            instructions[pc as usize] -= 1;
        } else {
            instructions[pc as usize] += 1;
        }
        pc += inst;
        steps += 1;
    }

    println!("{:?}",steps);
}
