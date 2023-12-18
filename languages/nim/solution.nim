import os, strutils

let
  inputFile = paramStr(1)
  part = paramStr(2)

var lines = readFile(inputFile).splitLines
if lines.len > 0 and lines[lines.len - 1] == "":
  lines.setLen(lines.len - 1)
let linesCount = lines.len

echo "Received ", linesCount, " lines of input for part ", part
