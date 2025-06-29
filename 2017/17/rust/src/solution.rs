use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let steps = content.trim_end().parse::<u32>().unwrap();

    let mut buffer = vec![0];
    let mut idx = 0;

    if part == "1" {
        for val in 1..2018 {
            let len = buffer.len() as u32;
            idx = (idx + steps) % len;
            if idx == len - 1 {
                buffer.push(val);
            } else {
                buffer.insert((idx + 1) as usize, val);
            }
            idx += 1;
        }
        idx = (buffer.iter().position(|n| n == &2017).unwrap() + 1) as u32;
        println!("{:?}", buffer[idx as usize]);
    } else {
        let mut last_written = 0;
        let mut len = 0;
        for val in 1..50_000_000 {
            len += 1;
            idx = (idx + steps) % len;
            if idx == 0 { last_written = val; }
            idx += 1;
        }
        println!("{:?}", last_written);
    }
}
