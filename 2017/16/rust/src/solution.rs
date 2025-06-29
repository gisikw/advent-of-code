use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let steps = content.trim_end().split(",").map(|str| {
        let mut step = vec![&str[0..1]];
        for part in str[1..].split("/") { step.push(part); }
        step
    }).collect();

    let mut programs: Vec<char> = "abcdefghijklmnop".chars().collect();
    let ref_programs = programs.clone();

    if part == "1" { 
        dance(&mut programs, &steps);
    } else {
        // Assuming we start in a loop
        let mut cycle_size = 0;
        loop {
            dance(&mut programs, &steps);
            cycle_size += 1;
            if programs == ref_programs { break; }
        }
        for _ in 0..(1_000_000_000 % cycle_size) {
            dance(&mut programs, &steps);
        }
    }

    println!("{}", programs.iter().collect::<String>());
}

fn dance(programs: &mut Vec<char>, steps: &Vec<Vec<&str>>) {
    for step in steps {
        match step[0] {
            "s" => programs.rotate_right(step[1].parse::<usize>().unwrap()),
            "x" => programs.swap(step[1].parse::<usize>().unwrap(), step[2].parse::<usize>().unwrap()),
            "p" => {
                let a = programs.iter().position(|p| p == &step[1].chars().next().unwrap()).unwrap();
                let b = programs.iter().position(|p| p == &step[2].chars().next().unwrap()).unwrap();
                programs.swap(a, b);
            }
            _ => unreachable!()
        }
    }
}
