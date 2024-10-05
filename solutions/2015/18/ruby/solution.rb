input_file = ARGV[0]
@part = ARGV[1]

grid = File.read(input_file).chomp.split("\n").map { |l| l.split('') }
if @part == "2"
  grid[0][0] = "#"
  grid[0][-1] = "#"
  grid[-1][0] = "#"
  grid[-1][-1] = "#"
end

def tick(grid)
  new_grid = Array.new(grid.size) { Array.new(grid[0].size) }
  grid.each_index do |y|
    grid.each_index do |x|
      neighbors = 0
      neighbors += 1 if x > 0 && y > 0 && grid[y-1][x-1] == '#'
      neighbors += 1 if y > 0 && grid[y-1][x] == '#'
      neighbors += 1 if y > 0 && grid[y-1][x+1] == '#'
      neighbors += 1 if x > 0 && grid[y][x-1] == '#'
      neighbors += 1 if grid[y][x+1] == '#'
      neighbors += 1 if x > 0 && grid[y+1] && grid[y+1][x-1] == '#'
      neighbors += 1 if grid[y+1] && grid[y+1][x] == '#'
      neighbors += 1 if grid[y+1] && grid[y+1][x+1] == '#'
      if neighbors == 3
        new_grid[y][x] = '#'
      elsif neighbors == 2 && grid[y][x] == '#'
        new_grid[y][x] = '#'
      else
        new_grid[y][x] = '.'
      end
    end
  end
  if @part == "2"
    new_grid[0][0] = "#"
    new_grid[0][-1] = "#"
    new_grid[-1][0] = "#"
    new_grid[-1][-1] = "#"
  end
  new_grid
end

100.times { grid = tick(grid) }
puts grid.flatten.join.scan(/#/).size
