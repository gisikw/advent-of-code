input_file = shellArgs[1]
part = shellArgs[2]

line_count = file.readLines(input_file).len
print "Received " + line_count + " lines of input for part " + part
