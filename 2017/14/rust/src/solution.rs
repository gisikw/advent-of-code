use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let mut grid: Vec<Vec<char>> = vec![];

    let mut sum = 0;
    for i in 0..128 {
        let str = format!("{}-{}",content.trim_end(),i);
        let hashed = knot_hash(&str);
        let binary = hex_to_bits(&hashed);
        grid.push(binary.chars().collect());
        sum += binary.chars().filter(|c| c == &'1').count();
    }

    if part == "1" {
        println!("{:?}", sum);
        std::process::exit(0);
    }

    let mut groups = 0;
    while let Some((row, col)) = find_bit(&grid) {
        groups += 1;
        purge(&mut grid, row as i32, col as i32);
    }

    println!("{:?}", groups);
}

fn knot_hash(str: &str) -> String {
    let mut lengths = str.chars().map(|c| c as i32).collect::<Vec<i32>>();
    lengths.append(&mut vec![17,31,73,47,23]);
    let mut list: Vec<u32> = (0..256).collect();
    let len = list.len() as i32;
    let mut idx: i32 = 0;
    let mut skip: i32 = 0;

    for _ in 0..64 {
        lengths.iter().copied().for_each(|l| {
            perform_round(&mut list, idx, l);
            idx += (skip + l) % len;
            skip += 1;
        });
    }

    list.as_slice().chunks(16).map(xor_hex).collect::<String>()
}

fn perform_round(list: &mut Vec<u32>, idx: i32, l: i32) {
    let len = list.len() as i32;
    let mut left = idx % len;
    let mut right = (idx + l - 1) % len;

    while left != right && (left + len - 1) % len != right {
        list.swap(left as usize, right as usize);
        left = (left + 1) % len;
        right = (right + len - 1) % len;
    }
}

fn xor_hex(chunk: &[u32]) -> String {
    let num = chunk.iter().copied().reduce(|acc, num| acc ^ num).unwrap();
    format!("{:02x}", num)
}

fn hex_to_bits(str: &str) -> String {
    str.chars()
        .map(|c| u32::from_str_radix(std::str::from_utf8(&[c as u8]).unwrap(), 16).unwrap())
        .map(|n| format!("{:04b}", n))
        .collect()
}

fn find_bit(grid: &Vec<Vec<char>>) -> Option<(usize,usize)> {
    let mut r = 0;
    for row in grid {
        let mut c = 0;
        for col in row {
            if col == &'1' { return Some((r, c)); }
            c += 1;
        }
        r += 1;
    }
    None
}

fn purge(grid: &mut Vec<Vec<char>>, row: i32, col: i32) {
    let old_char = grid[row as usize][col as usize];
    grid[row as usize][col as usize] = ' ';
    if old_char == '1' {
        if grid.get((row - 1) as usize).is_some() { purge(grid, row - 1, col); }
        if grid.get((row + 1) as usize).is_some() { purge(grid, row + 1, col); }
        if grid[row as usize].get((col - 1) as usize).is_some() { purge(grid, row, col - 1); }
        if grid[row as usize].get((col + 1) as usize).is_some() { purge(grid, row, col + 1); }
    }
}
