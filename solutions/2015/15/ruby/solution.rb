input_file = ARGV[0]
part = ARGV[1]

@ingredients = []

File.read(input_file).each_line do |line|
  @ingredients << line.scan(/-?\d+/).map(&:to_i)
end

weights = @ingredients.map { 100 / @ingredients.size }

def fitness(weights)
  scores = weights.map.with_index do |weight, i|
    @ingredients[i].map { |v| v * weight }[0..-2]
  end.reduce([0,0,0,0]) do |obj, property|
    obj.map.with_index { |_,i| obj[i] + property[i] }
  end
  return scores.min if scores.min < 1
  scores.reduce(:*)
end

if part == "1"
  while true
    score = fitness(weights)
    best_candidate = nil
    candidate_score = score

    weights.each_index do |add|
      weights.each_index do |sub|
        next if add == sub
        new_weights = weights.dup
        new_weights[add] += 1
        new_weights[sub] -= 1
        new_score = fitness(new_weights)
        if new_score > candidate_score
          best_candidate = new_weights
          candidate_score = new_score
        end
      end
    end

    break if candidate_score == score
    weights = best_candidate  
  end
else
  options = []
  100.downto(0).each do |a|
    (100 - a).downto(0).each do |b|
      (100 - a - b).downto(0).each do |c|
        options << [a,b,c,100 - a - b - c]
      end
    end
  end
  options.select! { |opt| opt.map.with_index { |_,i| @ingredients[i][4] * opt[i] }.reduce(:+) == 500 }
  weights = options.sort_by { |opt| fitness(opt) }[-1]
end

puts fitness(weights)
