import "os" for Process
import "io" for File

var args = Process.allArguments
var lines = File.read(args[2]).split("\n")
var part = Num.fromString(args[3])

var DIGITS = "1234567890"

var sum = 0
var enabled = true
for (line in lines) {
  var len = line.count
  if (len == 0) continue
  var i = 0

  while(true) {
    if (!enabled && part == 2) {
      var nextDo = line.indexOf("do()", i) + 3
      if (nextDo < 0 || nextDo < i) break
      enabled = true
      i = nextDo
    }

    var nextMul = line.indexOf("mul(", i) + 3
    if (nextMul < 0 || nextMul < i) break

    if (enabled && part == 2) {
      var nextDont = line.indexOf("don't()", i) + 6
      if (nextDont > 0 && nextDont >= i && nextDont < nextMul) {
        enabled = false
        i = nextDont
        continue
      }
    }

    i = nextMul

    var firstNum = ""
    while (true) {
      if (DIGITS.contains(line[i+1])) {
        i = i + 1
        firstNum = firstNum + line[i]
      } else break
    }
    if (firstNum.count == 0) continue 
    firstNum = Num.fromString(firstNum)

    if (line[i+1] == ",") {
      i = i + 1
    } else continue

    var secondNum = ""
    while (true) {
      if (DIGITS.contains(line[i+1])) {
        i = i + 1
        secondNum = secondNum + line[i]
      } else break
    }
    if (secondNum.count == 0) continue 
    secondNum = Num.fromString(secondNum)

    if (line[i+1] == ")") {
      i = i + 1
    } else continue

    sum = sum + (firstNum * secondNum)
  }
}

System.print(sum)
