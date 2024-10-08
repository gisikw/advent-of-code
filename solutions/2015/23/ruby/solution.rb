input_file = ARGV[0]
part = ARGV[1]

registers = {"a" => 0, "b" => 0}
pc = 0

registers["a"] = 1 if part == "2"

lines = File.read(input_file).lines

while line = lines[pc]
  case line
    when /^hlf (\w)/
      registers[Regexp.last_match[1]] /= 2
    when /tpl (\w)/
      registers[Regexp.last_match[1]] *= 3
    when /inc (\w)/
      registers[Regexp.last_match[1]] += 1
    when /jmp \+?(-?\d+)/
      pc += Regexp.last_match[1].to_i - 1
    when /jie (\w), \+?(-?\d+)/
      pc += Regexp.last_match[2].to_i - 1 if registers[Regexp.last_match[1]] % 2 == 0
    when /jio (\w), \+?(-?\d+)/
      pc += Regexp.last_match[2].to_i - 1 if registers[Regexp.last_match[1]] == 1
  end
  # puts [pc, line, registers["a"], registers["b"]].inspect
  pc += 1
end

puts registers["b"]
