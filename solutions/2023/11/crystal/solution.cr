input_file = ARGV[0]
part = ARGV[1]

class PQueue
  @contents : Array(Array(Int32))

  def initialize
    @contents = [[0]]
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
  @expanded_rows : Array(Int32)
  @expanded_cols : Array(Int32)

  def initialize(file)
    @rows = File.read_lines(file).map { |line| line.split("") }
    @expanded_rows = @rows.each_index.select { |i| @rows[i].all? { |c| c == "." }}.to_a
    @expanded_cols = @rows[0].each_index.select { |i| @rows.all? { |r| r[i] == "." }}.to_a
  end

  def to_s(io : IO)
    io << @rows.map { |row| row.join("") }.join("\n")
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

  def distances(source, dests, scale)
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

    until pq.empty? # || dests.all? { |d| visited.has_key?(d[0]) && visited[d[0]].has_key?(d[1]) } too much a perf hit
      score, row, col = pq.pop
      next if visited[row][col]
      visited[row][col] = true
      [[row+1,col],[row-1,col],[row,col+1],[row,col-1]]
        .select { |n| dist.has_key?(n[0]) && dist[n[0]].has_key?(n[1]) }
        .each do |neighbor|
          next_row, next_col = neighbor
          weight = 1
          weight = scale if @expanded_rows.includes?(row) && row != next_row
          weight = scale if @expanded_cols.includes?(col) && col != next_col
          alt = score + weight
          dist[next_row][next_col] = alt if alt < dist[next_row][next_col]
          pq << [dist[next_row][next_col], next_row, next_col]
        end
    end

    return dests.map {|d| dist[d[0]][d[1]]}
  end
end

scale_value = part == "1" ? 2 : 1000000
map = Map.new(input_file)
map.expand
galaxies = map.galaxies
distances = (0..galaxies.size-2).map do |i|
  map.distances(galaxies[i], galaxies[i+1..-1], scale_value)
end.flatten
puts distances.join("\n")
puts distances.reduce(0.to_i64) { |acc, num| acc + num.to_i64 }
