use std::cell::RefCell;
use std::env;
use std::fs;
use std::rc::Rc;

#[derive(Debug)]
struct Machine {
    buttons: Rc<Vec<Vec<usize>>>,
    charges: Vec<usize>,
    best_presses: Rc<RefCell<usize>>,
    press_count: usize,
}

impl Machine {
    fn new(desc: String) -> Self {
        let parts: Vec<&str> = desc.split(" ").collect();

        let charge_str = parts.last().unwrap().trim_matches(['{', '}']);
        let charges: Vec<usize> = charge_str
            .split(",")
            .map(|s| s.parse::<usize>().unwrap())
            .collect();

        let buttons: Vec<Vec<usize>> = parts[1..parts.len() - 1]
            .iter()
            .map(|s| {
                s.trim_matches(['(', ')'])
                    .split(",")
                    .map(|n| n.parse::<usize>().unwrap())
                    .collect()
            })
            .collect();

        Self {
            charges,
            buttons: Rc::new(buttons),
            best_presses: Rc::new(RefCell::new(usize::MAX)),
            press_count: 0,
        }
    }

    fn with_press(&self, index: usize, times: usize) -> Option<Self> {
        let mut charges = self.charges.clone();
        for &col in &self.buttons[index] {
            if charges[col] < times {
                return None;
            }
            charges[col] -= times;
        }

        Some(Self {
            charges,
            press_count: self.press_count + times,
            buttons: Rc::clone(&self.buttons),
            best_presses: Rc::clone(&self.best_presses),
        })
    }

    fn choose_next_col(&self) -> usize {
        let mut min_val = usize::MAX;
        let mut result = 0;

        for (col, value) in self.charges.iter().enumerate() {
            if *value == 0 {
                continue;
            }

            // let rows = self.buttons.iter().filter(|b| b.contains(&col)).count();
            // let heuristic = rows;
            let heuristic = *value;
            // let heuristic = rows * value;
            // let heuristic = binomial(value + rows - 1, rows - 1);

            if heuristic < min_val {
                result = col;
                min_val = heuristic;
            }
        }

        result
    }

    fn min_presses(&mut self) -> usize {
        let (max, sum) = self
            .charges
            .iter()
            .fold((0, 0), |(m, s), &x| (m.max(x), s + x));

        if self.press_count + max >= *self.best_presses.borrow() {
            return usize::MAX;
        };

        if sum == 0 {
            let mut best = self.best_presses.borrow_mut();
            if self.press_count < *best {
                *best = self.press_count;
            }
            return self.press_count;
        }

        let col = self.choose_next_col();
        let mut rows: Vec<(usize, &Vec<usize>)> = self
            .buttons
            .iter()
            .enumerate()
            .filter(|(_, b)| b.contains(&col))
            .collect();

        rows.sort_by(|a, b| a.1.len().cmp(&b.1.len()));
        let row_indices = rows.into_iter().map(|(idx, _)| idx).collect();

        self.search_partitions(self.charges[col], row_indices)
    }

    fn search_partitions(&self, val: usize, rows: Vec<usize>) -> usize {
        if rows.len() == 1 {
            self.with_press(rows[0], val)
                .map(|mut m| m.min_presses())
                .unwrap_or(usize::MAX)
        } else {
            let mut min_seen: usize = usize::MAX;

            for n in 0..=val {
                if let Some(child) = self.with_press(rows[0], n) {
                    let result = child.search_partitions(val - n, rows[1..].to_vec());
                    if result < min_seen {
                        min_seen = result;
                    }
                }
            }
            min_seen
        }
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let input_file = &args[1];
    let part = &args[2];

    if part == "1" {
        panic!("Part 1 isn't supported; go use the smalltalk implementation");
    }

    let content = fs::read_to_string(input_file).expect("Something went wrong reading the file");
    let result: usize = content
        .lines()
        .map(|l| {
            println!("{}", l);
            Machine::new(l.to_string())
        })
        .map(|mut m| {
            let res = m.min_presses();
            println!("{}", res);
            res
        })
        .sum();

    println!("{}", result);
}
