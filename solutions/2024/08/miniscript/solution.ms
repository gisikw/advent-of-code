lines = file.readLines(shellArgs[1])
height = lines.len()
width = lines[0].len()

nodes = {}
for row in range(0, lines.len() - 1)
  line = lines[row].split("")
  for col in range(0, line.len() - 1)
    char = line[col]
    if char != "." then
      if nodes.hasIndex(char) == 0 then
        nodes[char] = []
      end if
      nodes[char].push([row, col])
    end if
  end for
end for

antinodes = {}
for kv in nodes
  values = kv.value
  for i in range(0, values.len() - 1)
    for j in range(0, values.len() - 1)
      if i == j then
        continue
      end if
      dr = values[i][0] - values[j][0]
      dc = values[i][1] - values[j][1]
      if shellArgs[2] == "1" then
        wave = 1
      else
        wave = 0
      end if
      while true
        wave += 1
        row = values[i][0] - (wave * dr)
        col = values[i][1] - (wave * dc)
        if row < 0 or row >= height or col < 0 or col >= width then
          break
        end if
        antinodes[[row, col]] = 1
        if shellArgs[2] == "1" then
          break
        end if
      end while
    end for
  end for
end for

print antinodes.sum
