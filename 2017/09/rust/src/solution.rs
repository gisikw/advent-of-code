use std::env;
use std::fs;
use std::iter::Peekable;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let mut stream = content.trim_end().chars().peekable();
    let (score, garbage) = parse_group(&mut stream, 1);
    match part.as_str() {
        "1" => println!("{:?}", score),
        "2" => println!("{:?}", garbage),
        _ => unreachable!()
    }
}

fn parse_group<I>(stream: &mut Peekable<I>, depth: u32) -> (u32, u32)
where I: Iterator<Item = char> {
    let mut score = depth;
    let mut garbage = 0;
    stream.next();
    while let Some(c) = stream.peek() {
        match c {
            '}' => { stream.next(); break; }
            ',' => { stream.next(); }
            '<' => { garbage += parse_garbage(stream); }
            '{' => { 
                let (nested_score, nested_garbage) = parse_group(stream, depth + 1);
                score += nested_score;
                garbage += nested_garbage;
            }
            _ => unreachable!()
        }
    }
    (score, garbage)
}

fn parse_garbage<I>(stream: &mut Peekable<I>) -> u32
where I: Iterator<Item = char> {
    let mut garbage = 0;
    stream.next();
    while let Some(c) = stream.peek() {
        match c {
            '>' => { stream.next(); break; }
            '!' => { stream.next(); stream.next(); }
            _ => { garbage += 1; stream.next(); }
        }
    }
    garbage
}
