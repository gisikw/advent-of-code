import std

let args = command_line_arguments()
let input_file = args[0]
let part = args[1]


let contents = read_file(input_file)
let lines = tokenize(string(contents), "\n", "")

var a = string_to_int(substring(lines[0], 12, -1))
var b = string_to_int(substring(lines[1], 12, -1))
var c = string_to_int(substring(lines[2], 12, -1))

let inst = map(tokenize(substring(lines[4], 9, -1), ",", "")) i: 
  string_to_int(i)

def combo(i):
  return switch i:
    case 4:
      a
    case 5:
      b
    case 6:
      c
    default:
      i

if part == "1":
  let out = []
  var pc = 0
  while pc < length(inst):
    switch inst[pc]:
      case 0:
        a = a / pow(2, combo(inst[pc+1]))
      case 1:
        b = b ^ inst[pc+1]
      case 2:
        b = combo(inst[pc + 1]) % 8
      case 3:
        if a != 0:
          pc = inst[pc + 1] - 2
      case 4:
        b = b ^ c
      case 5:
        push(out, number_to_string(combo(inst[pc + 1]) % 8, 10, 1))
      case 6:
        b = a / pow(2, combo(inst[pc+1]))
      case 7:
        c = a / pow(2, combo(inst[pc+1]))
    pc += 2

  print(concat_string(out, ","))
else:
  def partTwo(i):
    let out = []
    a = i
    b = 0
    c = 0
    while a != 0:
      b = a % 8
      b = b ^ 5
      c = a / pow(2, b)
      b = b ^ 6
      a = a / 8
      b = b ^ c
      push(out, b % 8)
    return out

  var i = 0
  let partial = []
  while length(inst):
    insert(partial, 0, pop(inst)) 
    while not equal(partTwo(i), partial):
      i++
    i *= 8
  print i / 8
