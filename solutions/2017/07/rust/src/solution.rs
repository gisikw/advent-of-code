use std::env;
use std::fs;
use std::collections::HashMap;

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
            match line.split(" -> ").collect::<Vec<&str>>()[..] {
                [id_weight, children] => { 
                    let vals: Vec<&str> = id_weight.split(" (").collect();
                    let name = vals[0];
                    let weight: i32 = vals[1][0..vals[1].len()-1].parse().unwrap();
                    Some(Node { name, weight, total_weight: 0, children: children.split(", ").collect() })
                }
                [id_weight] => { 
                    let vals: Vec<&str> = id_weight.split(" (").collect();
                    let name = vals[0];
                    let weight: i32 = vals[1][0..vals[1].len()-1].parse().unwrap();
                    Some(Node { name, weight, total_weight: 0, children: vec![] })
                },
                _ => None
            }.unwrap()
        }).collect();

    let root = nodes
        .iter()
        .find(|node| {
            !nodes.iter().any(|other| {
              other.children.iter().any(|n| *n == node.name)
            })
        }).unwrap();

    if part == "1" {
        println!("{}", root.name);
        std::process::exit(0);
    } 

    let mut map: HashMap<&str, Node> = HashMap::new();
    nodes.iter().for_each(|node| { map.insert(node.name, node.clone()); });

    let mut stack = vec![(root.name,false)];
    while !stack.is_empty() {
        let (name, visited) = stack.pop().unwrap();
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
    while !stack.is_empty() {
        let (name, target_weight) = stack.pop().unwrap();
        let node = map.get(name).unwrap();
        let children: Vec<&Node> = node.children.iter().map(|c| map.get(c).unwrap()).collect();
        let weights: Vec<i32> = children.iter().map(|c| c.total_weight).collect();
        if children.len() < 2 {
            println!("{:?}", target_weight - weights.iter().sum::<i32>());
        } else {
            let mut uniq_weights = weights.clone();
            uniq_weights.sort();
            uniq_weights.dedup();
            match uniq_weights.len() {
                1 => {
                    println!("{:?}", target_weight - weights.iter().sum::<i32>());
                }
                _ => {
                    let correct_weight = match weights.len() {
                        2 => {
                            (target_weight - node.weight) / 2
                        }
                        _ => {
                            if weights[0] == weights[1] || weights[0] == weights[2] {
                                weights[0]
                            } else {
                                weights[1]
                            }
                        }
                    };
                    stack.push((children.iter().find(|c| c.total_weight != correct_weight).unwrap().name, correct_weight));
                }
            }
        }
    }
}
