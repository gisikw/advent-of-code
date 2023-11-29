function main(args)
    input_file = args[1]
    part = args[2]
    content = read(input_file, String)
    lines = split(content, '\n', keepempty=false)  # Exclude empty lines resulting from a trailing newline
    lines_count = length(lines)

    println("Received $lines_count lines of input for part $part")
end

main(ARGS)
