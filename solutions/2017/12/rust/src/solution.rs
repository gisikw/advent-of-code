use std::env;
use std::fs;
use std::collections::{HashMap,HashSet};

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let mut map: HashMap<&str,Vec<&str>> = HashMap::new();
    let mut nodes: HashSet<&str> = HashSet::new();

    content.lines().for_each(|line| {
        let parts: Vec<&str> = line.trim_end().split(" <-> ").collect();
        map.insert(parts[0], parts[1].split(", ").collect());
        nodes.insert(parts[0]);
    });

    if part == "1" {
        let seen = find_chain("0", &map);
        println!("{:?}", seen.len());
    } else {
        let mut groups = 0;
        while nodes.len() > 0 {
            let next = nodes.iter().next().unwrap();
            let seen = find_chain(next, &map);
            nodes = nodes.difference(&seen).copied().collect();
            groups += 1;
        }
        println!("{:?}", groups);
    }
}

fn find_chain<'a>(src: &str, map: &HashMap<&'a str,Vec<&'a str>>) -> HashSet<&'a str> {
    let mut seen: HashSet<&str> = HashSet::new();
    let mut queue = vec![src];
    while let Some(next) = queue.pop() {
        let dests = map.get(next).unwrap();
        for dest in dests.iter() {
            if !seen.contains(dest) {
                seen.insert(dest);
                queue.push(dest);
            }
        }
    }
    seen
}
