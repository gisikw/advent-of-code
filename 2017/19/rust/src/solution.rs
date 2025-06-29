use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let abcs = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".chars().collect::<Vec<char>>();
    let grid = content.lines().map(|line| line.chars().collect::<Vec<char>>()).collect::<Vec<Vec<char>>>();
    let mut row: i32 = 0;
    let mut col: i32 = grid[0].iter().position(|c| c == &'|').unwrap() as i32;
    let mut dir: i32 = 0;
    let mut seen: Vec<&char> = vec![];
    let mut steps = 0;

    loop {
        let space = cell(&grid, row, col).unwrap();
        if abcs.contains(space) { seen.push(space); }
        steps += 1;

        let [nrow, ncol] = next(row, col, dir);
        match cell(&grid, nrow, ncol) {
            None => { break; }
            Some(&' ') => {
                let [nrow, ncol] = next(row, col, dir + 1);
                if cell(&grid, nrow, ncol).unwrap_or(&' ') != &' ' {
                    [row, col] = [nrow, ncol];
                    dir += 1;
                } else {
                    let [nrow, ncol] = next(row, col, dir - 1);
                    if cell(&grid, nrow, ncol).unwrap_or(&' ') != &' ' {
                        [row, col] = [nrow, ncol];
                        dir = dir + 3 % 4;
                    } else {
                        break;
                    }
                }
            }
            Some(_) => {
                [row, col] = [nrow, ncol];
            }
        }
    }

    if part == "1" {
        println!("{}", seen.iter().copied().collect::<String>());
    } else {
        println!("{:?}", steps);
    }
}

fn next(row: i32, col: i32, dir: i32) -> [i32;2] {
    match (dir + 4) % 4 {
        0 => [row + 1, col],
        1 => [row, col - 1],
        2 => [row - 1, col],
        3 => [row, col + 1],
        _ => unreachable!()
    }
}

fn cell(grid: &Vec<Vec<char>>, r: i32, c: i32) -> Option<&char> {
    if r < 0 || c < 0 { return None; }
    match grid.get(r as usize) {
        Some(row) => row.get(c as usize),
        None => None
    }
}
