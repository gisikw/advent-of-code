input_file = ARGV[0]
part = ARGV[1]

reindeer = []

File.read(input_file).lines.each do |line|
  name, speed, stamina, rest = line.scan(/^(\w+) can fly (\d+) km\/s for (\d+).* (\d+) seconds./)[0]
  reindeer << { speed: speed.to_i, stamina: stamina.to_i, rest: rest.to_i, dist: 0, score: 0 }
end

total_time = 2503

if part == "1"
  puts (reindeer.map do |deer|
    cycles = total_time / (deer[:stamina] + deer[:rest])
    remaining_time = [total_time % (deer[:stamina] + deer[:rest]), deer[:stamina]].min
    (cycles * deer[:speed] * deer[:stamina]) +
    (remaining_time * deer[:speed])
  end.max)
else
  0.upto(total_time).each do |time|
    max_dist = 0
    reindeer.each do |deer|
      t = time % (deer[:stamina] + deer[:rest])
      deer[:dist] += deer[:speed] if t < deer[:stamina]
      max_dist = [max_dist, deer[:dist]].max
    end
    reindeer.select { |d| d[:dist] == max_dist }.each { |d| d[:score] += 1 }
  end
  puts reindeer.map { |d| d[:score] }.max
end
