def inputFile = args[0]
def part = args[1]
def lines = new File(inputFile).readLines()
println "Received ${lines.size()} lines of input for part $part"
