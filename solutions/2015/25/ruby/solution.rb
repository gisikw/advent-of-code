input_file = ARGV[0]
part = ARGV[1]

target_row, target_col = File.read(input_file).scan(/(\d+)[^\d]+(\d+)/)[0].map(&:to_i)

row = 1
col = 1
value = 20151125

while row != target_row || col != target_col
  value = value * 252533 % 33554393
  row, col = row == 1 ? [col + 1, 1] : [row - 1, col + 1]
end

puts value
