use std::env;
use std::fs;
use std::collections::HashMap;

fn write_map(map: &mut HashMap<(i32,i32),u32>, x: i32, y: i32) {
    map.insert(
        (x,y),
        [
            (x-1, y-1), (x-1, y), (x-1, y+1),
            (x, y-1), (x, y+1),
            (x+1, y-1), (x+1, y), (x+1, y+1)
        ].iter()
        .map(|coord| *map.get(&coord).unwrap_or(&0))
        .sum());
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];
    
    let num: u32 = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file")
        .trim_end()
        .parse()
        .unwrap();

    let mut x: i32 = 0;
    let mut y: i32 = 0;
    let mut step = 1;
    let mut count = 1;

    let mut map: HashMap<(i32,i32),u32> = HashMap::new();
    map.insert((x,y), 1);

    'main: while count < num {
        for _ in 1..step {
            x += 1;
            count += 1;
            if count == num { break 'main; }
            if part == "2" {
                write_map(&mut map, x, y);
                if *map.get(&(x,y)).unwrap() > num { break 'main; }
            }
        }
        for _ in 1..step {
            y -= 1;
            count += 1;
            if count == num { break 'main; }
            if part == "2" {
                write_map(&mut map, x, y);
                if *map.get(&(x,y)).unwrap() > num { break 'main; }
            }
        }
        step += 1;
        for _ in 1..step {
            x -= 1;
            count += 1;
            if count == num { break 'main; }
            if part == "2" {
                write_map(&mut map, x, y);
                if *map.get(&(x,y)).unwrap() > num { break 'main; }
            }
        }
        for _ in 1..step {
            y += 1;
            count += 1;
            if count == num { break 'main; }
            if part == "2" {
                write_map(&mut map, x, y);
                if *map.get(&(x,y)).unwrap() > num { break 'main; }
            }
        }
        step += 1;
    }

    if part == "2" {
        println!("{}", *map.get(&(x,y)).unwrap());
    } else {
        println!("{}", x.abs() + y.abs());
    }
}
