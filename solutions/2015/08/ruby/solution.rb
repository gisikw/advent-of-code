input_file = ARGV[0]
part = ARGV[1]

str_len = 0
mem_len = 0
diff = 0

if part == "1"
  File.read(input_file).lines.each do |line|
    line.strip!
    str_len += line.size  
    mem_len += line.gsub("\\\\","X").gsub("\\\"","X").gsub(/\\x[0-9a-f]{2}/,"X").size - 2 
  end
else
  File.read(input_file).lines.each do |line|
    line.strip!
    str_len += line.dump.size
    mem_len += line.size
  end
end

puts str_len - mem_len
