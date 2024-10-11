use std::env;
use std::fs;
use std::collections::{HashMap,VecDeque};

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");
    let lines: Vec<&str> = content.lines().collect();

    if part == "1" {
        part_one(&lines);
    } else {
        part_two(&lines);
    }
}

fn part_one(lines: &Vec<&str>) {
    let mut pc: i64 = 0;
    let mut frequency = 0;
    let mut map: HashMap<&str,i64> = HashMap::new();
    while let Some(line) = lines.get(pc as usize) {
        let parts: Vec<&str> = line.split_whitespace().collect();
        match parts[0] {
            "snd" => { frequency = resolve(parts[1], &map); }
            "set" => { map.insert(parts[1], resolve(parts[2], &map)); }
            "add" => { map.insert(parts[1], resolve(parts[1], &map) + resolve(parts[2], &map)); }
            "mul" => { map.insert(parts[1], resolve(parts[1], &map) * resolve(parts[2], &map)); }
            "mod" => { map.insert(parts[1], resolve(parts[1], &map) % resolve(parts[2], &map)); }
            "jgz" => { if resolve(parts[1], &map) > 0 { pc += resolve(parts[2], &map) - 1; } }
            "rcv" => {
                if resolve(parts[1], &map) > 0 { 
                    println!("{:?}", frequency);
                    std::process::exit(0);
                }
            }
            _ => unreachable!()
        }
        pc += 1;
    }
    println!("{:?}", map);
}

fn part_two(lines: &Vec<&str>) {
    let mut pc: [i64;2] = [0,0];
    let mut map: [HashMap<&str,i64>;2] = [HashMap::new(), HashMap::new()];
    let mut queue: [VecDeque<i64>;2] = [VecDeque::new(), VecDeque::new()];

    map[0].insert("p",0);
    map[1].insert("p",1);

    let mut p = 0;
    let mut q = 1;

    let mut sends = 0;

    loop {
        let line = lines.get(pc[p] as usize);
        if line.is_none() { if p == 1 { break; } else { p = 1; } };
        let line = line.unwrap();
        let parts: Vec<&str> = line.split_whitespace().collect();
        match parts[0] {
            "set" => { map[p].insert(parts[1], resolve(parts[2], &map[p])); }
            "add" => { map[p].insert(parts[1], resolve(parts[1], &map[p]) + resolve(parts[2], &map[p])); }
            "mul" => { map[p].insert(parts[1], resolve(parts[1], &map[p]) * resolve(parts[2], &map[p])); }
            "mod" => { map[p].insert(parts[1], resolve(parts[1], &map[p]) % resolve(parts[2], &map[p])); }
            "jgz" => { if resolve(parts[1], &map[p]) > 0 { pc[p] += resolve(parts[2], &map[p]) - 1; } }
            "snd" => { 
                queue[q].push_back(resolve(parts[1], &map[p])); 
                if p == 1 { sends += 1; }
            }
            "rcv" => {
                if let Some(val) = queue[p].pop_front() {
                    map[p].insert(parts[1], val);
                } else {
                    let other_inst = lines.get(pc[q] as usize);
                    if other_inst.is_none() || (queue[q].is_empty() && other_inst.unwrap().split_whitespace().next().unwrap() == "rcv") {
                        break;
                    }
                    let tmp = p;
                    p = q;
                    q = tmp;
                    continue;
                }
            }
            _ => unreachable!()
        }
        pc[p] += 1;
    }
    println!("{:?}",sends);
}

fn resolve(str: &str, map: &HashMap<&str,i64>) -> i64 {
    match str.parse::<i64>() {
        Ok(num) => num,
        _ => *map.get(str).unwrap_or(&0)
    }
}
