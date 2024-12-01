package main

import "core:fmt"
import "core:os"
import "core:strings"

main :: proc() {
    input_file := os.args[1]
    part := os.args[2]

    data, ok := os.read_entire_file(input_file, context.allocator)
    defer delete(data, context.allocator)

    line_count := 0
    it := string(data)
    for line in strings.split_lines_iterator(&it) {
      line_count = line_count + 1
    }

    fmt.println("Received", line_count, "lines of input for part", part)
}
