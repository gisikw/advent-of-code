use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let parts = content.lines().map(|line| {
        let split = line.split("/").collect::<Vec<&str>>();
        [split[0].parse::<usize>().unwrap(),split[1].parse::<usize>().unwrap()]
    }).collect::<Vec<[usize;2]>>();

    let mut stack: Vec<(Vec<[usize;2]>,Vec<[usize;2]>,usize)> = vec![
        (vec![],parts,0)
    ];

    let mut best_score = 0;
    let mut best: Vec<Vec<[usize;2]>> = vec![];
    while let Some((picked, remaining, target)) = stack.pop() {
        let mut found = false;
        for (i, piece) in remaining.iter().enumerate() {
            if piece[0] == target {
                found = true;
                let mut next_remaining = remaining.clone();
                let mut next_picked = picked.clone();
                next_picked.push(next_remaining.remove(i));
                stack.push((next_picked, next_remaining, piece[1]));
            } else if piece[1] == target {
                found = true;
                let mut next_remaining = remaining.clone();
                let mut next_picked = picked.clone();
                next_picked.push(next_remaining.remove(i));
                stack.push((next_picked, next_remaining, piece[0]));
            }
        }
        if !found || remaining.len() == 0 {
            let score = if part == "2" { picked.len() } else { picked.iter().flatten().sum() };
            if score > best_score { 
                best_score = score; 
                best.clear();
            }
            if score >= best_score { best.push(picked); }
        }
    }

    if part == "2" {
        best_score = 0;
        for picked in best {
            let score = picked.iter().flatten().sum();
            if score > best_score { best_score = score; }
        }
    }
    println!("{:?}", best_score);
}
