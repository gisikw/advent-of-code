input_file = ARGV[0]
part = ARGV[1]

strings = File.read(input_file).lines

if part == "1"
  nice_strings = strings
    .select { |str| str.scan(/[aeiou]/).size > 2 } 
    .select { |str| str.scan(/(\w)\1/).size > 0 }
    .reject { |str| str.scan(/ab|cd|pq|xy/).size > 0 }
else
  nice_strings = strings
    .select { |str| str.scan(/(\w\w).*\1/).size > 0 }
    .select { |str| str.scan(/(\w)\w\1/).size > 0 }
end

puts nice_strings.size
