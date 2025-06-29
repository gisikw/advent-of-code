use std::env;
use std::fs;
use std::collections::HashMap;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let mut states: HashMap<&str,[(i64,i64,&str);2]> = HashMap::new();
    let mut tape: HashMap<i64,i64> = HashMap::new();

    let mut lines = content.lines();
    let mut state = &lines.next().unwrap()[15..16];
    let checksum = lines.next().unwrap().split_whitespace().nth(5).unwrap().parse::<usize>().unwrap();
    lines.next();

    while let Some(header) = lines.next() {
       let state = &header[9..10]; 
       lines.next();
       let lval = lines.next().unwrap()[22..23].parse::<i64>().unwrap();
       let ldir = if lines.next().unwrap().split_whitespace().nth(6).unwrap() == "right." { 1 } else { -1 };
       let lnxt = &lines.next().unwrap()[26..27];
       lines.next();
       let hval = lines.next().unwrap()[22..23].parse::<i64>().unwrap();
       let hdir = if lines.next().unwrap().split_whitespace().nth(6).unwrap() == "right." { 1 } else { -1 };
       let hnxt = &lines.next().unwrap()[26..27];
       lines.next();
       states.insert(state, [(lval,ldir,lnxt),(hval,hdir,hnxt)]);
    }

    let mut idx = 0;
    for _ in 0..checksum {
        let branch = tape.get(&idx).unwrap_or(&0);
        let (val, dir, nxt) = states.get(state).unwrap()[*branch as usize];
        tape.insert(idx, val);
        idx += dir;
        state = nxt;
    }

    println!("{:?}", tape.values().sum::<i64>());
}
