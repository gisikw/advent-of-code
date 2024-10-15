use std::env;
use std::fs;
use std::collections::HashMap;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");
    let lines: Vec<&str> = content.lines().collect();

    if part == "2" {
        let mut b = 107900;
        let c = 124900;
        let mut h = 0;
        loop {
            let mut f = 1;
            let mut d = 2;
            loop {
                if b % d == 0 { f = 0; }
                d += 1;
                if d == ((b as f64).sqrt() as usize) { break; }
            }
            if f == 0 { h += 1; }
            if b == c { break; }
            b += 17;
        }
        println!("{:?}", h);
        std::process::exit(0);
    }

    let mut pc: i64 = 0;
    let mut map: HashMap<&str,i64> = HashMap::new();
    let mut count = 0;
    while let Some(line) = lines.get(pc as usize) {
        let parts: Vec<&str> = line.split_whitespace().collect();
        match parts[0] {
            "set" => { map.insert(parts[1], resolve(parts[2], &map)); }
            "sub" => { map.insert(parts[1], resolve(parts[1], &map) - resolve(parts[2], &map)); }
            "jnz" => { if resolve(parts[1], &map) != 0 { pc += resolve(parts[2], &map) - 1; } }
            "mul" => { 
                map.insert(parts[1], resolve(parts[1], &map) * resolve(parts[2], &map)); 
                count += 1;
            }
            _ => unreachable!()
        }
        pc += 1;
    }
    println!("{:?}", count);
}

fn resolve(str: &str, map: &HashMap<&str,i64>) -> i64 {
    match str.parse::<i64>() {
        Ok(num) => num,
        _ => *map.get(str).unwrap_or(&0)
    }
}
