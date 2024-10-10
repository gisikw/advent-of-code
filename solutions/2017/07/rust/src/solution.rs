use std::env;
use std::fs;
use std::collections::{HashMap,HashSet};

#[derive(Clone, Debug)]
struct Node<'a> {
    name: &'a str,
    weight: i32,
    total_weight: i32,
    children: Vec<&'a str>
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file) 
        .expect("Something went wrong reading the file");

    let nodes: Vec<Node> =
        content.lines().map(|line| {
            let parts: Vec<&str> = line.split(" -> ").collect();
            let name_weight: Vec<&str> = parts[0].split(" (").collect();
            let name = name_weight[0];
            let weight: i32 = name_weight[1][0..name_weight[1].len()-1].parse().unwrap();
            let children = if parts.len() > 1 {
                parts[1].split(", ").collect()
            } else {
                vec![]
            };
            Node { name, weight, total_weight: 0, children }
        }).collect();

    let all_children: HashSet<&str> = nodes
        .iter()
        .flat_map(|node| node.children.iter())
        .cloned()
        .collect();

    let root = nodes
        .iter()
        .find(|node| !all_children.contains(node.name))
        .unwrap();

    if part == "1" {
        println!("{}", root.name);
        std::process::exit(0);
    } 

    let mut map: HashMap<&str, Node> = HashMap::new();
    nodes.iter().for_each(|node| { map.insert(node.name, node.clone()); });

    let mut stack = vec![(root.name,false)];
    while let Some((name, visited)) = stack.pop() {
        if visited {
            let node = map.get(name).unwrap();
            let total_weight: i32 = node.weight + node.children.iter().map(|c| map.get(c).unwrap().total_weight).sum::<i32>();
            map.get_mut(name).unwrap().total_weight = total_weight;
        } else {
            stack.push((name, true));
            map.get(name).unwrap().children.iter().for_each(|c| stack.push((c,false)));
        }
    }

    let mut stack = vec![(root.name,0)];
    while let Some((name, target_weight)) = stack.pop() {
        let node = map.get(name).unwrap();
        let children = node.children.iter().map(|c| map.get(c).unwrap());
        let weights: Vec<i32> = children.clone().map(|c| c.total_weight).collect();
        let mut uniq_weights: Vec<i32> = weights.iter().copied().collect();
        uniq_weights.sort();
        uniq_weights.dedup();
        if children.len() < 2 || uniq_weights.len() == 1 {
            println!("{:?}", target_weight - weights.iter().sum::<i32>());
            std::process::exit(0);
        }
        let correct_weight = if weights.len() == 2{
            (target_weight - node.weight) / 2
        } else {
            if weights[0] == weights[1] || weights[0] == weights[2] {
                weights[0]
            } else {
                weights[1]
            }
        };
        let offender = children.clone().find(|c| c.total_weight != correct_weight).unwrap().name;
        stack.push((offender, correct_weight));
    }
}
