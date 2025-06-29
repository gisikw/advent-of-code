input_file = ARGV[0]
part = ARGV[1]

grid = Array.new(1000) { Array.new(1000) { 0 } }

File.read(input_file).lines.each do |step|
  x1, y1, x2, y2 = step.scan(/(\d+),(\d+)/).flatten.map(&:to_i)

  op = case step
    when /^turn on/
      part == "1" ? 
        -> (x,y) { grid[x][y] = 1 } : 
        -> (x,y) { grid[x][y] += 1 }
    when /^turn off/
      -> (x,y) { grid[x][y] = [grid[x][y]-1,0].max }
    when /^toggle/
      part == "1" ? 
        -> (x,y) { grid[x][y] = grid[x][y] == 1 ? 0 : 1 } : 
        -> (x,y) { grid[x][y] += 2 }
    end

  x1.upto(x2) { |x| y1.upto(y2) { |y| op.call(x,y) } }
end

puts grid.flatten.inject(:+)
