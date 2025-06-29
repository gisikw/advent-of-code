import os
import math

struct Coord {
    x int
    y int
}

fn (c Coord) neighbors() []Coord {
    mut result := []Coord{}
    if c.x > 0 {
        result << Coord{c.x - 1, c.y}
    }
    if c.x < 70 {
        result << Coord{c.x + 1, c.y}
    }
    if c.y > 0 {
        result << Coord{c.x, c.y - 1}
    }
    if c.y < 70 {
        result << Coord{c.x, c.y + 1}
    }
    return result
}

struct Node {
    coord Coord
    f f64
    g int
    h f64
}

fn main() {
    args := os.args.clone()

    input_file := args[1]
    content := os.read_file(input_file)!
    lines := content.split_into_lines()

    part := args[2]

    if part == "1" {
        println(pathfind(lines, 1024)!)
        return
    }

    mut lo := 1024
    mut hi := lines.len
    for ; hi - lo > 1; {
        mid := (hi + lo) / 2
        if pathfind(lines, mid)! == -1 {
            hi = mid
        } else {
            lo = mid
        }
    }
    println(lines[lo])
}

fn pathfind(lines []string, bytes int) !int {

    blocked := lines[0..bytes]
                .map(it.split(","))
                .map(Coord{it[0].int(), it[1].int()})

    mut closed_list := []Coord{}
    mut open_list := []Node{}

    open_list << Node{Coord{0,0}, 0, 0, 0}

    for ; open_list.len > 0; {
        mut idx := 0
        mut lowest_f := open_list[0].f
        for i, node in open_list {
            if node.f < lowest_f {
                idx = i
                lowest_f = node.f
            }
        }

        node := open_list[idx]
        open_list.delete(idx)
        closed_list << node.coord

        if node.coord.x == 70 && node.coord.y == 70 {
            return node.g
        }

        out: for neighbor in node.coord.neighbors()
                                .filter(!blocked.contains(it)) {
            if closed_list.contains(neighbor) {
                continue out
            }

            g := node.g + 1
            h := math.sqrt(
                math.pow(70 - neighbor.x, 2) + 
                math.pow(70 - neighbor.y, 2))
            f := g + h

            neighbor_node := Node{neighbor, f, g, h}
            

            mut tbd := []int{}
            for i, open in open_list {
                if open.coord == neighbor {
                    if neighbor_node.g < open.g {
                        tbd << i
                    } else {
                        continue out
                    }
                }
            }
            for d in tbd {
                open_list.delete(d)
            }

            open_list << neighbor_node
        }
    }

    return -1
}
