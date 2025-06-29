input_file = ARGV[0]
part = ARGV[1]

expected = %q{
  children: 3
  cats: 7
  samoyeds: 2
  pomeranians: 3
  akitas: 0
  vizslas: 0
  goldfish: 5
  trees: 3
  cars: 2
  perfumes: 1
}.split("\n")[1..-1].map(&:strip)

if part == "1"
  File.read(input_file).each_line do |line|
    num, facts = line.scan(/Sue (\d+): (.*)/)[0]
    expected.each { |e| facts.gsub!(e,'') }
    puts num unless facts =~ /[^\s,]/
  end
else
  expected.reject! do |line|
    line =~ /cats|trees|pomeranians|goldfish/
  end.map! do |line|
    Regexp.new line.gsub(/\d/) { |match| "[^#{match}]" }
  end
  File.read(input_file).each_line do |line|
    num, facts = line.scan(/Sue (\d+): (.*)/)[0]
    next if expected.any? { |e| facts =~ e }
    facts = Hash[*facts.split(",").flat_map { |pair| pair.split(":").map(&:strip) }]
    next if facts["cats"] && facts["cats"].to_i <= 7
    next if facts["trees"] && facts["trees"].to_i <= 3
    next if facts["pomeranians"] && facts["pomeranians"].to_i >= 3
    next if facts["goldfish"] && facts["goldfish"].to_i >= 5
    puts num
  end
end
