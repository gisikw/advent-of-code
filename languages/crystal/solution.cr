input_file = ARGV[0]
part = ARGV[1]
lines_count = File.read_lines(input_file).size

puts "Received #{lines_count} lines of input for part #{part}"
