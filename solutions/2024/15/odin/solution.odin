package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:slice"

show_grid :: proc(grid: [50][100]int) {
    for line in grid {
        for char in line {
            fmt.print(rune(char));
        }
        fmt.print("\n");
    }
}

main :: proc() {
    input_file := os.args[1]
    part := os.args[2]

    data, ok := os.read_entire_file(input_file, context.allocator)
    defer delete(data, context.allocator)

    sections := strings.split(string(data), "\n\n");
    grid: [50][100]int;
    for line, row in strings.split_lines(sections[0]) {
        for char, col in line {
            if part == "1" {
                grid[row][col] = int(char); 
            } else {
                switch char {
                    case '#':
                        grid[row][col*2] = int('#')
                        grid[row][col*2+1] = int('#')
                    case 'O':
                        grid[row][col*2] = int('[')
                        grid[row][col*2+1] = int(']')
                    case '.':
                        grid[row][col*2] = int('.')
                        grid[row][col*2+1] = int('.')
                    case '@':
                        grid[row][col*2] = int('@')
                        grid[row][col*2+1] = int('.')
                }
            }
        }

    }
    steps, ok2 := strings.replace_all(sections[1],"\n","");

    x := 0;
    y := 0;
    for row, r in grid {
        for cell, c in row {
            if cell == '@' {
                y = r;
                x = c;
            }
        }
    }

    move: for step, idx in steps {
        switch step {
            case '>':
                i := x + 1;
                for ; grid[y][i] > '.'; i += 1 {}
                if grid[y][i] == '#' { continue; }
                for ; i > x; i -= 1 {
                    grid[y][i] = grid[y][i-1];
                }
                grid[y][x] = '.';
                x += 1;
            case '<':
                i := x - 1;
                for ; grid[y][i] > '.'; i -= 1 {}
                if grid[y][i] == '#' { continue; }
                for ; i < x; i += 1 {
                    grid[y][i] = grid[y][i+1];
                }
                grid[y][x] = '.';
                x -= 1;
            case '^':
                if part == "1" {
                    i := y - 1;
                    for ; grid[i][x] > '.'; i -= 1 {}
                    if grid[i][x] == '#' { continue; }
                    for ; i < y; i += 1 {
                        grid[i][x] = grid[i+1][x];
                    }
                    grid[y][x] = '.';
                    y -= 1;
                } else {
                    layers: [dynamic][dynamic]int;
                    layer: [dynamic]int;
                    append(&layer, y, x);
                    append(&layers, layer);

                    // Building up the move tree
                    for {
                        next_row := layer[0] - 1;
                        next_layer: [dynamic]int = {next_row}
                        for layer_x in layer[1:] {
                            switch grid[next_row][layer_x] {
                                case '#':
                                    continue move;
                                case '[':
                                    append(&next_layer, layer_x, layer_x + 1);
                                case ']':
                                    append(&next_layer, layer_x, layer_x - 1);
                            }
                        }
                        if (len(next_layer) == 1) { 
                            break; 
                        }
                        layer = next_layer;
                        append(&layers, layer);
                    }

                    // Doing the moves
                    for i := len(layers) - 1; i >= 0; i -= 1 {
                        row := layers[i][0];
                        cols := layers[i][1:];
                        slice.sort(cols);
                        cols = slice.unique(cols);
                        for col in cols {
                            grid[row-1][col] = grid[row][col];
                            grid[row][col] = '.';
                        }
                    }
                    y -= 1;
                }
            case 'v':
                if part == "1" {
                    i := y + 1;
                    for ; grid[i][x] > '.'; i += 1 {}
                    if grid[i][x] == '#' { continue; }
                    for ; i > y; i -= 1 {
                        grid[i][x] = grid[i-1][x];
                    }
                    grid[y][x] = '.';
                    y += 1;
                } else {
                    layers: [dynamic][dynamic]int;
                    layer: [dynamic]int;
                    append(&layer, y, x);
                    append(&layers, layer);

                    // Building up the move tree
                    for {
                        next_row := layer[0] + 1;
                        next_layer: [dynamic]int = {next_row}
                        for layer_x in layer[1:] {
                            switch grid[next_row][layer_x] {
                                case '#':
                                    continue move;
                                case '[':
                                    append(&next_layer, layer_x, layer_x + 1);
                                case ']':
                                    append(&next_layer, layer_x, layer_x - 1);
                            }
                        }
                        if (len(next_layer) == 1) { break; }
                        layer = next_layer;
                        append(&layers, layer);
                    }

                    // Doing the moves
                    for i := len(layers) - 1; i >= 0; i -= 1 {
                        row := layers[i][0];
                        cols := layers[i][1:];
                        slice.sort(cols);
                        cols = slice.unique(cols);
                        for col in cols {
                            grid[row+1][col] = grid[row][col];
                            grid[row][col] = '.';
                        }
                    }
                    y += 1;

                }
        }
    }

    sum := 0;
    for row, r in grid {
        for cell, c in row {
            if cell == 'O' || cell == '[' {
                sum += (r * 100) + c;
            }
        }
    }
    fmt.println(sum);
}
