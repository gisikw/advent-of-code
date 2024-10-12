use std::env;
use std::fs;
use std::convert::TryInto;
use std::collections::{HashMap,HashSet};

#[derive(Debug,Copy,Clone,Eq,Hash,PartialEq)]
struct Particle {
    id: usize,
    pos: [i64;3],
    vel: [i64;3],
    acc: [i64;3],
    pos_sum: i64,
    vel_sum: i64,
    acc_sum: i64,
}

impl Particle {
    fn tick(&mut self) {
        for axis in 0..3 {
            self.vel[axis] += self.acc[axis];
            self.pos[axis] += self.vel[axis];
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let mut particles: Vec<Particle> = vec![];
    for (id, line) in content.lines().enumerate() {
        let parts: Vec<&str> = line.split(", ").collect();
        
        let pos_str = &parts[0][3..parts[0].len()-1];
        let vel_str = &parts[1][3..parts[1].len()-1];
        let acc_str = &parts[2][3..parts[2].len()-1];

        let pos: [i64;3] = pos_str.split(",").map(|s| s.parse::<i64>().unwrap()).collect::<Vec<i64>>().try_into().unwrap();
        let vel: [i64;3] = vel_str.split(",").map(|s| s.parse::<i64>().unwrap()).collect::<Vec<i64>>().try_into().unwrap();
        let acc: [i64;3] = acc_str.split(",").map(|s| s.parse::<i64>().unwrap()).collect::<Vec<i64>>().try_into().unwrap();

        let pos_sum = pos.iter().map(|v| v.abs()).sum();
        let vel_sum = vel.iter().map(|v| v.abs()).sum();
        let acc_sum = acc.iter().map(|v| v.abs()).sum();

        let particle = Particle { id, pos, vel, acc, pos_sum, vel_sum, acc_sum };

        particles.push(particle);
    }

    if part == "1" {
        // Sorting by vel/pos turned out not to be necessary, but who cares
        let min_acc = particles.iter().map(|p| p.acc_sum).min().unwrap();
        particles = particles.iter().filter(|p| p.acc_sum == min_acc).copied().collect();
        let min_vel = particles.iter().map(|p| p.vel_sum).min().unwrap();
        particles = particles.iter().filter(|p| p.vel_sum == min_vel).copied().collect();
        let min_pos = particles.iter().map(|p| p.pos_sum).min().unwrap();
        particles = particles.iter().filter(|p| p.pos_sum == min_pos).copied().collect();
        println!("{:?}", particles[0].id);
        std::process::exit(0);
    }

    for _ in 0..1000 {
        let mut positions: HashMap<[i64;3],usize> = HashMap::new();
        let mut collisions: HashSet<usize> = HashSet::new();
        for particle in particles.iter_mut() {
            if let Some(collision) = positions.get(&particle.pos) {
                collisions.insert(*collision);
                collisions.insert(particle.id);
            } else {
                positions.insert(particle.pos, particle.id);
            }
            particle.tick();
        }
        if collisions.len() > 0 {
            for id in collisions { 
                let idx = particles.iter().position(|p| p.id == id).unwrap();
                particles.remove(idx);
            }
        }
    }
    println!("{:?}", particles.len());
}
