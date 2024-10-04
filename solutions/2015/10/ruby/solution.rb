input_file = ARGV[0]
part = ARGV[1]

string = File.read(input_file).strip

def look_and_say(str)
  str.gsub(/(\d)\1*/).map { |d| "#{d.size}#{d[0]}" }.join()
end

if part == "1"
  40.times { string = look_and_say(string) }
else
  50.times { string = look_and_say(string) }
end

puts string.size
