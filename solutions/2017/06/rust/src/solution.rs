use std::env;
use std::fs;
use std::collections::HashMap;

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let mut nums: Vec<u32> = 
        fs::read_to_string(input_file)
        .expect("Something went wrong reading the file")
        .trim_end()
        .split("\t")
        .map(|s| s.parse::<u32>().unwrap())
        .collect();

    let mut steps = 0;
    let mut last_seen: HashMap<Vec<u32>,u32> = HashMap::new();
    last_seen.insert(nums.clone(), steps);

    loop {
        let mut blocks: u32 = *nums.iter().max().unwrap();
        let len = nums.len();
        let mut i: usize = 0;

        while nums[i] != blocks { i += 1 }
        nums[i] = 0;
        while blocks > 0 {
            i = (i + 1) % len;
            nums[i] += 1;
            blocks = blocks - 1;
        }

        steps += 1;
        if last_seen.contains_key(&nums) { break; }
        last_seen.insert(nums.clone(), steps);
    }

    if part == "1" {
        println!("{:?}", steps);
    } else {
        println!("{:?}", steps - last_seen.get(&nums).unwrap());
    }
}
