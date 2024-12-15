let args = command_line_arguments()
let input_file = args[0]
let part = args[1]

let contents = read_file(input_file)
let lines = tokenize(string(contents), "\n", "")
print("Received {length(lines)} lines of input for part {part}")
