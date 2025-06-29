function main(args)
  grid, size, start_pos = parse_input(args[1])
  part = args[2]
  if part == "1"
    println(for_steps(grid, size, start_pos, [64])[1])
  else
    y0, y1, y2 = for_steps(grid, size, start_pos, 
                           [size ÷ 2, size + size ÷ 2, 2 * size + size ÷ 2])
    x0, x1, x2 = 0, 1, 2
    f = create_quadratic(x0, y0, x1, y1, x2, y2)
    println(f((26501365 - size ÷ 2) ÷ 131))
  end
end

function create_quadratic(x0, y0, x1, y1, x2, y2)
  A = [x1^2 x1; x2^2 x2]
  B = [y1 - y0; y2 - y0]
  a, b = A \ B
  function quadratic(x)
    return Int(floor(a * x^2 + b * x + y0))
  end
  return quadratic
end

function for_steps(grid, size, start_pos, steps)
  results = []
  nodes = Set([start_pos])
  step_index = 1
  for i in 1:maximum(steps)
    next_nodes = Set()
    while length(nodes) > 0
      node = pop!(nodes)
      for delta in [-1, 1, -1im, 1im]
        neighbor_pos = wrap(node + delta, size)
        if grid[neighbor_pos] != '#'
          push!(next_nodes, node + delta)
        end
      end
    end
    nodes = next_nodes
    if i == steps[step_index]
      push!(results, length(nodes))
      step_index += 1
    end
  end
  return results
end

function parse_input(input_file)
  content = read(input_file, String)
  lines = split(content, '\n', keepempty=false)
  grid = Dict{Complex{Int}, Char}()
  size = length(lines)
  start_pos = 0 + 0im
  for i in 1:size
    for j in 1:size
      grid[i + j*im] = lines[i][j]
      if lines[i][j] == 'S'
        start_pos = i + j*im
      end
    end
  end
  return grid, size, start_pos
end

function wrap(pos, size)
  wrapped_row = (((real(pos) - 1) % size) + size) % size + 1
  wrapped_col = (((imag(pos) - 1) % size) + size) % size + 1
  return wrapped_row + wrapped_col*im
end

main(ARGS)
