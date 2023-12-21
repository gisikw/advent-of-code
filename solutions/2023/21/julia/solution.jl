function main(args)
  input_file = args[1]
  part = args[2]

  content = read(input_file, String)
  grid = map(s -> String.(split(s,"")), String.(split(content, '\n', keepempty=false)))

  start_row = 0
  start_col = 0

  for i in 1:length(grid)
    for j in 1:length(grid[i])
      if cmp(grid[i][j],"S") == 0
        start_row = i
        start_col = j
      end
    end
  end

  queue = Set([[start_row, start_col]])
  for i in 1:64
    next_queue = Set()
    while length(queue) > 0
      node = pop!(queue)
      row = node[1]
      col = node[2]

      if row > 1 && cmp(grid[row-1][col],"#") != 0
        push!(next_queue, [row-1,col])
      end

      if col < length(grid[row]) && cmp(grid[row][col+1],"#") != 0
        push!(next_queue, [row,col+1])
      end

      if row < length(grid) && cmp(grid[row+1][col],"#") != 0
        push!(next_queue, [row+1,col])
      end

      if col > 1 && cmp(grid[row][col-1],"#") != 0
        push!(next_queue, [row,col-1])
      end
    end
    queue = next_queue
  end

  println(length(queue))
end

main(ARGS)
