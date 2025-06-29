input_file = ARGV[0]
part = ARGV[1]

@wires = {}

File.read(input_file).lines.each do |line|
  desc, id = line.strip.split(' -> ')
  @wires[id] = { desc: desc, state: nil }
end

def resolve(id)
  id.scan(/\d/).size > 0 ? id.to_i : get_state(id)
end

def get_state(wire)
  @wires[wire][:state] ||= begin
    case @wires[wire][:desc]
      when /^NOT (\w+)/
        match = Regexp.last_match
        ~resolve(match[1])
      when /(\w+) OR (\w+)/
        match = Regexp.last_match
        resolve(match[1]) | resolve(match[2])
      when /(\w+) AND (\w+)/
        match = Regexp.last_match
        resolve(match[1]) & resolve(match[2])
      when /(\w+) LSHIFT (\w+)/
        match = Regexp.last_match
        resolve(match[1]) << resolve(match[2])
      when /(\w+) RSHIFT (\w+)/
        match = Regexp.last_match
        resolve(match[1]) >> resolve(match[2])
      else
        resolve(@wires[wire][:desc])
    end
  end
end

if part == "2"
  @wires["b"][:desc] = get_state("a").to_s
  @wires.each { |k,v| v[:state] = nil }
end
puts get_state("a")
