use std::env;
use std::fs;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let mut q: i32 = 0;
    let mut r: i32 = 0;
    let mut max_dist: i32 = 0;

    content.trim_end().split(",").for_each(|step| {
        match step {
            "n" => { r -= 1; }
            "ne" => { q += 1; r -= 1; }
            "se" => { q += 1; }
            "s" => { r += 1; }
            "sw" => { q -= 1; r += 1; }
            "nw" => { q -= 1; }
            _ => unreachable!()
        }
        let s: i32 = -q - r;
        let dist = (q.abs() + r.abs() + s.abs()) / 2;
        if dist > max_dist { max_dist = dist; }
    });

    let s: i32 = -q - r;
    let dist = (q.abs() + r.abs() + s.abs()) / 2;

    match part.as_str() {
        "1" => println!("{:?}", dist),
        "2" => println!("{:?}", max_dist),
        _ => unreachable!()
    }
}
