input_file = ARGV[0]
part = ARGV[1]

@happiness = {}
names = []

File.read(input_file).lines.each do |line|
  p1, dir, mag, p2 = line.scan(/^(\w+) would (gain|lose) (\d+).* (\w+)./)[0]
  mag = mag.to_i * (dir == 'gain' ? 1 : -1)
  key = [p1,p2].sort.join
  names |= [p1,p2]
  @happiness[key] ||= 0
  @happiness[key] += mag
end

def score(seats)
  seats.map.with_index do |_, i|
    @happiness[[seats[i],seats[i+1]||seats[0]].sort.join] || 0
  end.inject(:+)
end

def best_score(picked, remaining)
  return score(picked) if remaining.empty?
  remaining.map { |p| best_score(picked | [p], remaining - [p]) }.max
end

names << "you" if part == "2"
puts best_score([], names)
