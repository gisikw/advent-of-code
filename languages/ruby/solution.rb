input_file = ARGV[0]
part = ARGV[1]

content = File.read(input_file)
lines_count = content.lines.count

puts "Received #{lines_count} lines of input for part #{part}"
