use std::env;
use std::fs;
use std::collections::HashMap;
use std::convert::TryInto;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let mut registers: HashMap<&str, i32> = HashMap::new();
    let mut highest: i32 = 0;

    content.lines().for_each(|line| {
        let tokens: Vec<&str> = line.split_whitespace().collect();
        let [register, op, delta, _, comp_register, comparison, comp_val] = tokens.as_slice().try_into().unwrap();
        let delta = delta.parse::<i32>().unwrap();
        let comp_val = comp_val.parse::<i32>().unwrap();

        let creg_val = *registers.get(comp_register).unwrap_or(&0);
        let satisfied = match comparison {
            ">" => creg_val > comp_val,
            "<" => creg_val < comp_val,
            ">=" => creg_val >= comp_val,
            "<=" => creg_val <= comp_val,
            "==" => creg_val == comp_val,
            "!=" => creg_val != comp_val,
            &_ => unreachable!()
        };

        if satisfied {
            let initial_val = *registers.get(register).unwrap_or(&0);
            let next_val = match op {
                "inc" => initial_val + delta,
                "dec" => initial_val - delta,
                &_ => unreachable!()
            };
            if next_val > highest { highest = next_val }
            registers.insert(register, next_val);
        }
    });

    let result = match part.as_str() {
        "1" => registers.values().max().unwrap(),
        "2" => &highest,
        _ => unreachable!()
    };
    println!("{:?}", result);
}
