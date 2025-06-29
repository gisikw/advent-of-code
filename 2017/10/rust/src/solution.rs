use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let mut content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let lengths: Vec<i32> = if part == "1" {
        content.trim_end().split(",").map(|s| s.parse::<i32>().unwrap()).collect()
    } else {
        let mut tmp = content.trim_end().chars().map(|c| c as i32).collect::<Vec<i32>>();
        tmp.append(&mut vec![17,31,73,47,23]);
        tmp
    };

    let mut list: Vec<u32> = (0..256).collect();
    let len = list.len() as i32;
    let mut idx: i32 = 0;
    let mut skip: i32 = 0;

    if part == "1" {
        lengths.iter().copied().for_each(|l| {
            perform_round(&mut list, idx, l);
            idx += (skip + l) % len;
            skip += 1;
        });
        println!("{:?}", list[0] * list[1]);
        std::process::exit(0);
    }

    for _ in 0..64 {
        lengths.iter().copied().for_each(|l| {
            perform_round(&mut list, idx, l);
            idx += (skip + l) % len;
            skip += 1;
        });
    }

    let hash = list.as_slice().chunks(16).map(xor_hex).collect::<String>();
    println!("{}", hash);
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
