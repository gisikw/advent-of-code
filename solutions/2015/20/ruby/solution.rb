input_file = ARGV[0]
part = ARGV[1]

num = File.read(input_file).chomp.to_i

# Ignoring perfect squares, so they'll be wrong
def sum_factors(n)
  1.upto(Math.sqrt(n))
    .select { |i| n % i == 0 }
    .flat_map { |i| [i, n / i] }
    .reduce(:+)
end

def sum_factors_weird(n)
  1.upto(Math.sqrt(n))
    .select { |i| n % i == 0 }
    .flat_map { |i| [i, n / i] }
    .reject { |i| i * 50 < n }
    .reduce(:+)
end

i = 1
if part == "1"
  i += 1 until sum_factors(i) >= num / 10
else
  i += 1 until sum_factors_weird(i) >= num / 11
end
puts i
