args := System args

inputFile := args at(1)
part := args at(2)

content := File with(inputFile) contents
lines := content split("\n")
linesCount := lines size

("Received " .. linesCount asString .. " lines of input for part " .. part) println
