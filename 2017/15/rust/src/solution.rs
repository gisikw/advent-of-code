use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let nums: Vec<u64> = content.split_whitespace().filter_map(|t| t.parse::<u64>().ok()).collect();
    let mut a = nums[0];
    let mut b = nums[1];

    let mask: u64 = 65535;
    let mut count = 0;

    if part == "1" {
        for _ in 0..40_000_000 {
            a = (a * 16807) % 2147483647;
            b = (b * 48271) % 2147483647;
            if (a & mask) == (b & mask) { count += 1; }
        }
    } else {
        for _ in 0..5_000_000 {
            loop {
                a = (a * 16807) % 2147483647;
                if a % 4 == 0 { break; }
            }
            loop {
                b = (b * 48271) % 2147483647;
                if b % 8 == 0 { break; }
            }
            if (a & mask) == (b & mask) { count += 1; }
        }
    }

    println!("{:?}", count);
}
