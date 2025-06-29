use std::env;
use std::fs;
use std::collections::HashMap;

enum State {
    Weakened,
    Infected,
    Flagged
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let center = (content.len() as f64).sqrt() as i64 / 2;
    let mut infected: HashMap<[i64;2], State> = HashMap::new();

    for (row, line) in content.lines().enumerate() {
        for (col, char) in line.chars().enumerate() {
            if char == '#' {
                infected.insert([row as i64, col as i64], State::Infected);
            }
        }
    }

    let dirs = [[-1,0], [0,1], [1,0], [0,-1]];
    let mut row = center;
    let mut col = center;
    let mut dir = 0;
    let mut count = 0;

    if part == "1" {
        let max = 10000;
        for _ in 0..max {
            if infected.contains_key(&[row,col]) {
                dir = (dir + 1) % 4;
                infected.remove(&[row,col]);
            } else {
                count += 1;
                dir = (dir + 3) % 4;
                infected.insert([row,col], State::Infected);
            }
            row += dirs[dir][0];
            col += dirs[dir][1];
        }
    } else {
        let max = 10000000;
        for _ in 0..max {
            match infected.get(&[row,col]) {
                Some(State::Weakened) => {
                    count += 1;
                    infected.insert([row,col], State::Infected);
                }
                Some(State::Infected) => {
                    dir = (dir + 1) % 4;
                    infected.insert([row,col], State::Flagged);
                }
                Some(State::Flagged) => {
                    dir = (dir + 2) % 4;
                    infected.remove(&[row,col]);
                }
                _ => {
                    dir = (dir + 3) % 4;
                    infected.insert([row,col], State::Weakened);
                }
            }
            row += dirs[dir][0];
            col += dirs[dir][1];
        }
    }
    println!("{:?}", count);
}
