input_file = ARGV[0]
part = ARGV[1]

content = File.read(input_file)

def visit_sequence(sequence, visited)
  x,y = 0,0
  sequence.each do |dir| 
    case dir
      when '>'
        x += 1
      when '<'
        x -= 1
      when '^'
        y -= 1
      when 'v'
        y += 1
    end
    visited << "#{x},#{y}"
  end
end

visited = Set.new
visited << "0,0"
sequence = File.read(input_file).split('')
if part == "1"
  visit_sequence(sequence, visited)
else
  sequence.partition.with_index { |_, i| i % 2 == 0 }.each do |seq|
    visit_sequence(seq, visited)
  end
end
puts visited.size
