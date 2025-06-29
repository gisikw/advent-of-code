use std::env;
use std::fs;
use std::collections::HashMap;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let mut pattern = ".#...####".to_string();

    let mut transforms: HashMap<String,String> = HashMap::new();
    for line in content.trim_end().lines() {
        let parts = line.split(" => ").map(|sec| sec.chars().filter(|c| c != &'/').collect::<String>()).collect::<Vec<String>>();
        transforms.insert(parts[0].clone(), parts[1].clone()); 
    }

    let max = if part == "1" { 5 } else { 18 };
    let mut count = 0;

    // for _ in 0..max {
    //     let chunks = split(&pattern);
    //     let new_chunks = chunks.iter().map(|c| transform(&c, &transforms)).collect();
    //     pattern = join(&new_chunks);
    // }
    // count = pattern.chars().filter(|c| c == &'#').count();

    // Not faster, but amenable to memoization
    let mut count = 0;
    let mut stack: Vec<(String,usize)> = vec![(pattern, max)];
    while let Some((str, depth)) = stack.pop() {
        if depth == 0 {
            count += str.chars().filter(|c| c == &'#').count();
            continue;
        }
        if str.len() % 2 == 0 {
            stack.push((
                join(&split(&str).iter().map(|c| transform(&c, &transforms)).collect()),
                depth - 1
            ));
        } else {
            for partial in split(&str) { 
                stack.push((transform(&partial, &transforms).to_string(), depth - 1)); 
            }
        }
    }
    println!("{:?}", count);
}

fn transform<'a>(str: &String, transforms: &'a HashMap<String,String>) -> &'a String {
    let ts = all_transforms(&str);
    ts.iter().find_map(|t| transforms.get(t).clone()).expect("REASON")
}

fn all_transforms(str: &String) -> [String;8] {
    [
        str.clone(),
        rotate(str),
        rotate(&rotate(str)),
        rotate(&rotate(&rotate(str))),
        flip_vertical(&str),
        flip_vertical(&rotate(str)),
        flip_vertical(&rotate(&rotate(str))),
        flip_vertical(&rotate(&rotate(&rotate(str)))),
    ]
}

fn flip_vertical(str: &String) -> String {
    match str.len() {
        4 => str[2..4].to_owned().clone() + &str[0..2],
        _ => str[6..9].to_owned().clone() + &str[3..6] + &str[0..3]
    }
}

fn rotate(str: &String) -> String {
    let chars: Vec<char> = str.chars().collect();
    match str.len() {
        4 => vec![
            chars[1], chars[3],
            chars[0], chars[2]
        ],
        _ => vec![
            chars[2], chars[5], chars[8],
            chars[1], chars[4], chars[7],
            chars[0], chars[3], chars[6]
        ]
    }.iter().collect()
}

fn split(str: &String) -> Vec<String> {
    let len = str.len();
    let size = match len % 2 { 0 => 2, _ => 3 };
    let width = (len as f64).sqrt() as usize;
    let mut chunks: Vec<String> = vec![];
    for row in 0..width/size {
        for col in 0..width/size {
            let idx = (row * width * size) + col * size;
            let mut new_str = str[idx..idx+size].to_owned().clone();
            new_str += &str[idx+width..idx+width+size];
            if size == 3 { new_str += &str[idx+width*2..idx+width*2+size]; }
            chunks.push(new_str);
            
        }
    }
    chunks
}

fn join(chunks: &Vec<&String>) -> String {
    let len = chunks.len();
    if len == 1 { return chunks[0].to_string() }
    let width = (len as f64).sqrt() as usize;
    let cwidth = (chunks[0].len() as f64).sqrt() as usize;
    chunks.chunks(width).map(|chunk| {
        let mut str = "".to_string();
        for row in 0..cwidth {
            for col in 0..width {
                str += &chunk[col][row*cwidth..row*cwidth+cwidth];
            }
        }
        str
    }).collect::<Vec<String>>().join("")
}
