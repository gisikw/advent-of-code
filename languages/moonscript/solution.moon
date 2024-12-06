input_file = arg[1]
part = arg[2]

lines_count = 0
for line in io.lines input_file
  lines_count += 1

print "Received #{lines_count} lines of input for part #{part}"
