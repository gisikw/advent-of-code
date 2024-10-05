input_file = ARGV[0]
part = ARGV[1]

nums = File.read(input_file).chomp.lines.map(&:to_i)

def count_options(selected, rejected, rest, size = nil)
  return (selected.reduce(:+) == 150 && (size && selected.size == size)) ? 1 : 0 if rest.empty?
  count_options(selected + [rest[0]], rejected, rest[1..-1], size) +
  count_options(selected, rejected + [rest[0]], rest[1..-1], size)
end

def minimal_containers(selected, rejected, rest)
  return selected.reduce(:+) == 150 ? selected.size : Float::INFINITY if rest.empty?
  [minimal_containers(selected + [rest[0]], rejected, rest[1..-1]),
  minimal_containers(selected, rejected + [rest[0]], rest[1..-1])].min
end

if part == "1"
  puts count_options([], [], nums)
else
  size = minimal_containers([], [], nums)
  # Heuristic: early-terminate the "add" branch if we've already got that amount
  puts count_options([], [], nums, size)
end
