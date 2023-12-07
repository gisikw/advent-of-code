import os

fn main() {
    args := os.args.clone()

    input_file := args[1]
    part := args[2]

    content := os.read_file(input_file)!

    lines := content.split_into_lines()
    lines_count := lines.len

    println('Received $lines_count lines of input for part $part')
}
