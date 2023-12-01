input_file = ARGV[0]
part = ARGV[1]

if part == "1"
  puts File.read(input_file).lines.map { |l| "#{l[/\d/]}#{l.reverse[/\d/]}".to_i }.reduce(:+)
else
  NUMS=%w(zero one two three four five six seven eight nine)
  values = File.read(input_file).lines.map do |line|
    first = line[/#{NUMS.join('|')}|\d/]
    last = (NUMS | [/\d/]).map do |n|
      line.scan(n)
      Regexp.last_match
    end.compact.sort_by { |match| match.offset(0)[0] }[-1].to_s
    first = NUMS.index(first) || first
    last = NUMS.index(last) || last
    "#{first}#{last}".to_i
  end
  puts values.reduce(:+)
end
