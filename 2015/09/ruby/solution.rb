input_file = ARGV[0]
part = ARGV[1]

@map = {}

File.read(input_file).lines.each do |line|
  origin, destination, distance = line.scan(/(\w+) to (\w+) = (\d+)/).flatten
  @map[origin] ||= {}
  @map[destination] ||= {}
  @map[origin][destination] = distance.to_i
  @map[destination][origin] = distance.to_i
end

def min_path(node, distance = 0, already_visited = [])
  return distance if already_visited.size == @map.keys.size - 1
  destinations = @map[node].keys.reject { |n| already_visited.include?(n) }
  return Float::INFINITY if destinations.empty?
  destinations.map { |n| min_path(n, distance + @map[node][n], already_visited | [node]) }.min
end

def max_path(node, distance = 0, already_visited = [])
  return distance if already_visited.size == @map.keys.size - 1
  destinations = @map[node].keys.reject { |n| already_visited.include?(n) }
  return 0 if destinations.empty?
  destinations.map { |n| max_path(n, distance + @map[node][n], already_visited | [node]) }.max
end

if part == "1"
  puts @map.keys.map { |k| min_path(k) }.min
else
  puts @map.keys.map { |k| max_path(k) }.max
end
