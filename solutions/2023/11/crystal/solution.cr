input_file = ARGV[0]
part = ARGV[1]

# Want to use Djikstra's algorithm to build a shortest-path tree to all destinations

# Going to actually expand the map rather than use weights, because the weights
# will be different vertically and horizontally, and it feels too easy to screw
# it up. Expanding seems to work without issue, so we'll just hope the weights
# are fine too.

# How to do this with weighting:
# - Add a weight cost for entering the square if it's from the expanding direction? Feels like it ought to work, but idk
# - Note: Initial attempt failed
#
# Other optimization: kill the algorithm if all destinations are accounted for.

class PQueue
  @contents : Array(Array(Int32))

  def initialize
    @contents = [[0]]
  end

  def contents
    @contents
  end

  def empty?
    @contents.size <= 1
  end

  def <<(item)
    @contents << item
    bubble_up(@contents.size - 1)
  end

  def bubble_up(index)
    parent_index = index // 2
    return if index <= 1
    return if @contents[parent_index][0] <= @contents[index][0]
    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def pop
    exchange(1, @contents.size - 1)
    min = @contents.pop
    bubble_down(1)
    min
  end

  def bubble_down(index)
    child_index = (index * 2)
    return if child_index > @contents.size - 1

    if child_index < @contents.size - 1
      left_element = @contents[child_index]
      right_element = @contents[child_index + 1]
      child_index += 1 if right_element[0] < left_element[0]
    end

    return if @contents[index][0] <= @contents[child_index][0]

    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @contents[source], @contents[target] = @contents[target], @contents[source]
  end
end

class Map
  @rows : Array(Array(String))

  def initialize(file)
    @rows = File.read_lines(file).map { |line| line.split("") }
  end

  def to_s(io : IO)
    io << @rows.map { |row| row.join("") }.join("\n")
  end

  def expand
    @rows = 
      @rows.reduce([] of Array(String)) { |acc, row|
        acc << row
        acc << row if row.all? { |c| c == "." }
        acc
      }.transpose.reduce([] of Array(String)) { |acc, row|
        acc << row
        acc << row if row.all? { |c| c == "." }
        acc
      }.transpose
  end

  def galaxies
    results = [] of Array(Int32)
    @rows.each_with_index do |row, r|
      row.each_with_index do |s, c|
        results << [r, c] if s == "#" 
      end
    end
    results
  end

  def distances(source, dests)
    dist = Hash(Int32, Hash(Int32, Int32)).new
    visited = Hash(Int32, Hash(Int32, Bool)).new
    pq = PQueue.new

    @rows.each_with_index do |row, r|
      dist[r] = Hash(Int32, Int32).new
      visited[r] = Hash(Int32, Bool).new
      row.each_index do |c|
        dist[r][c] = Int32::MAX
        visited[r][c] = false
      end
    end
    dist[source[0]][source[1]] = 0
    pq << source.unshift(dist[source[0]][source[1]])

    until pq.empty? # || dests.all? { |d| dist[d] < Int32::MAX } More expensive than it's worth
      score, row, col = pq.pop
      next if visited[row][col]
      visited[row][col] = true
      [[row+1,col],[row-1,col],[row,col+1],[row,col-1]]
        .select { |n| dist.has_key?(n[0]) && dist[n[0]].has_key?(n[1]) }
        .each do |neighbor|
          next_row, next_col = neighbor
          alt = score + 1
          dist[next_row][next_col] = alt if alt < dist[next_row][next_col]
          pq << [dist[next_row][next_col], next_row, next_col]
        end
    end

    return dests.map {|d| dist[d[0]][d[1]]}
  end
end

# PQueue: 12.3s -> 0.24s for a single distances call on a 64x64 grid
# Early termination might by more helpful on this larger grid
# Dangit, we're gonna need to scale ridiculously for part 2, which means weights

map = Map.new(input_file)
map.expand
galaxies = map.galaxies
# puts "Beginning the algorithm..."
# elapsed = Time.measure do
#   puts map.distances(galaxies[0], galaxies[1..-1])
# end
# puts elapsed
# puts "Number of galaxies to measure? #{galaxies.size}"
distances = (0..galaxies.size-2).map do |i|
  map.distances(galaxies[i], galaxies[i+1..-1])
end.flatten.reduce(0) { |acc, num| acc + num }
puts distances
