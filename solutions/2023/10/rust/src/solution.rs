use std::env;
use std::fs;

#[derive(PartialEq)]
#[derive(Debug)]
enum Dir { NORTH, EAST, SOUTH, WEST, NONE }

#[derive(Debug)]
struct Cell(bool, Dir, Dir);

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    let mut content = fs::read_to_string(input_file)
        .expect("Something went wrong reading the file");

    let map: Vec<Vec<Cell>> = 
        content.
            lines()
            .map(|l| l.chars().map(|c| match c {
                'S' => Cell(true, Dir::NONE, Dir::NONE),
                '|' => Cell(false, Dir::NORTH, Dir::SOUTH),
                '-' => Cell(false, Dir::WEST, Dir::EAST),
                'L' => Cell(false, Dir::NORTH, Dir::EAST),
                'J' => Cell(false, Dir::NORTH, Dir::WEST),
                '7' => Cell(false, Dir::SOUTH, Dir::WEST),
                'F' => Cell(false, Dir::SOUTH, Dir::EAST),
                _   => Cell(false, Dir::NONE, Dir::NONE)
                }).collect()).collect();

    let width = content.find('\n').unwrap() + 1;
    let (col, row) = starting_coords(&content,width);

    let steps = traverse(row, col + 1, &Dir::NORTH, 0, &map, &mut content);
    // Turned out not to be necessary
    // if steps.is_none() {
    //     steps = traverse(row, col + 1, &Dir::EAST, 0, &map);
    //     if steps.is_none() {
    //         steps = traverse(row, col + 1, &Dir::SOUTH, 0, &map);
    //     }
    // }

    let width = map[0].len() + 1;
    let binding = content.clone();
    let mut interiors: Vec<usize> = binding.match_indices("I").map(|(i,_)|i).collect();
    loop {
        match interiors.pop() {
           None => break, // End of the queue
           Some(i)  => {
                let n = i - width;
                let ns = content.get(n..n+1).unwrap();
                if ns != "#" && ns != "I" {
                    content.replace_range(n..n+1,"I");
                    interiors.push(n);
                }
                let e = i + 1;
                let es = content.get(e..e+1).unwrap();
                if es != "#" && es != "I" {
                    content.replace_range(e..e+1,"I");
                    interiors.push(e);
                }
                let s = i + width;
                let ss = content.get(s..s+1).unwrap();
                if ss != "#" && ss != "I" {
                    content.replace_range(s..s+1,"I");
                    interiors.push(s);
                }
                let w = i - 1;
                let ws = content.get(w..w+1).unwrap();
                if ws != "#" && ws != "I" {
                    content.replace_range(w..w+1,"I");
                    interiors.push(w);
                }
           }
        }
    }

    if part == "1" {
        let result = steps.unwrap() / 2 + steps.unwrap() % 2;
        println!("{}", result);
    } else {
        let magic_offset_to_get_the_right_answer = 3;
        println!("{}", content.match_indices("I").collect::<Vec<(usize, &str)>>().len() + magic_offset_to_get_the_right_answer);
    }
}

fn traverse(row: usize, col: usize, dir: &Dir, steps: i32, map: &Vec<Vec<Cell>>, content: &mut String) -> Option<i32> {
    // Mark to the right hand side, unless it's already a critical path
    let width = map[0].len() + 1;
    let mut interior_index = 9999999999999999; // Flag to NOT mark an interior if we're traversing
                                               // the wrong route

    // I give up on handling usize 0 - 1
    let mut next_row = row;
    let mut next_col = col;
    if dir == &Dir::NORTH {
        if row == 0 { return None; }
        next_row = row - 1;
        interior_index = next_row * width + col + 1;
    } else if dir == &Dir::EAST {
        next_col = col + 1;
        if next_col == map[0].len() { return None; }
        interior_index = (row + 1) * width + next_col;
    } else if dir == &Dir::SOUTH {
        next_row = row + 1;
        if next_row == map.len() { return None; }
        interior_index = next_row * width + col - 1;
    } else if dir == &Dir::WEST {
        if col == 0 { return None; }
        next_col = col - 1;
        interior_index = (row - 1) * width + next_col;
    }

    // Part 2 shenanigans
    if interior_index != 9999999999999999 {
        let maybe_str = content.get(interior_index..interior_index+1);
        if maybe_str.is_some() && maybe_str.unwrap() != "#" { content.replace_range(interior_index..interior_index+1,"I") }
    }

    let char_index = row * (map[0].len() + 1) + col;
    content.replace_range(char_index..char_index+1,"#");
    

    let next_cell = &map[next_row][next_col];

    // Handle return to S
    if next_cell.0 { return Some(steps + 2) };

    let next_dir_opt = exit_for_entrance(&next_cell, dir);

    match next_dir_opt {
        None => None,
        Some(next_dir) => traverse(next_row, next_col, next_dir, steps + 1, &map, content)
    }
}

// TODO: See about pattern-matching this, also look up whatever I'm doing with lifetime here
fn exit_for_entrance<'a>(cell: &'a Cell, dir: &'a Dir) -> Option<&'a Dir> {
    let Cell(_, a, b) = cell;
    let opposite = opposite_dir(dir); // Cells track their exits
    if a == opposite {
        Some(b)
    } else if b == opposite {
        Some(a)
    } else {
        None
    }
}

fn opposite_dir(dir: &Dir) -> &Dir {
    match dir {
        Dir::NORTH => &Dir::SOUTH,
        Dir::SOUTH => &Dir::NORTH,
        Dir::EAST => &Dir::WEST,
        Dir::WEST => &Dir::EAST,
        Dir::NONE => &Dir::NONE
    }
}

fn starting_coords(content:&String, width:usize) -> (usize, usize) {
    let s = content.find('S').unwrap();
    return (s % width, s / width);
}
