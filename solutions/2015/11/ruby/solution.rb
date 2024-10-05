input_file = ARGV[0]
part = ARGV[1]

@abcs = "abcdefghijklmnopqrstuvwxyza"
@straights = Regexp.new(
  0.upto(23)
    .map { |i| @abcs[i..i+2] }
    .reject { |seq| seq =~ /[iol]/ }
    .join('|')
)
@abcs.gsub!(/[iol]/,'')

def is_valid?(password)
  return false unless password =~ @straights
  password.scan(/(\w)\1/).flatten.uniq.size > 1
end

# Heuristic TODO: A valid password will be due to completing a run or a pair,
# so we don't need to test more than that
def increment_password(password)
  i = -1
  while true
    password[i] = @abcs[@abcs.index(password[i]) + 1]
    return password if password[i] != 'a'
    i -= 1
  end
end

string = File.read(input_file).strip
string = increment_password(string) until is_valid?(string)
if part == "2"
  increment_password(string)
  string = increment_password(string) until is_valid?(string)
end
puts string
