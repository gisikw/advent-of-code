input_file = ARGV[0]
part = ARGV[1]

content = File.read(input_file).chomp.lines
@transforms = content[0..-3].map { |s| s.chomp.split(' => ') }
@molecule = content[-1]

if part == "1"
  new_molecules = []
  @transforms.each do |tr|
    count = @molecule.scan(tr[0]).size
    next if count < 1
    1.upto(count).each do |i|
      new_molecules << @molecule.gsub(tr[0]).with_index do |match, j|
        (i - 1) == j ? tr[1] : match 
      end
    end
  end
  puts new_molecules.uniq.size
else
  # DFS Reversed - Greedy
  def shortest_path(str, steps = 0, best = Float::INFINITY)
    return steps if str == "e"
    return Float::INFINITY if (steps > best)
    next_strs = []
    @transforms.each do |tr|
      count = str.scan(tr[1]).size
      next if count < 1
      1.upto(count).each do |i|
        next_strs << str.gsub(tr[1]).with_index { |m,j| (i-1) == j ? tr[0] : m }
      end
    end
  
    next_strs.sort_by { |s| s.size }.each do |next_str|
      res = shortest_path(next_str, steps + 1, best)
      # (puts res; $stdout.flush) if res < best
      best = res if res < best
    end

    best
  end
  puts shortest_path(@molecule)
end
