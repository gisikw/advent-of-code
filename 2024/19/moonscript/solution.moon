input_file = arg[1]
part = arg[2]

lines = [line for line in io.lines input_file]
towels = [word for word in lines[1]\gmatch("%w+")]

cache = {"":1}
compositions = (whole, parts) ->
  if cache[whole] == null
    sum = 0
    for part in *parts
      if whole\sub(0, #part) == part
        sum += compositions(whole\sub(#part + 1), parts)
    cache[whole] = sum
  return cache[whole]

sum = 0
if part == "1"
  for line in *lines[3,]
    sum += 1 if compositions(line, towels) > 0
else
  sum = 0
  for line in *lines[3,]
    sum += compositions line, towels
print string.format("%.0f",sum)
