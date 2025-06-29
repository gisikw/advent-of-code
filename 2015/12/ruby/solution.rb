require 'json'

input_file = ARGV[0]
@part = ARGV[1]

tree = JSON.parse(File.read(input_file))

def sum(node)
  case node
    when Numeric
      node
    when String
      0
    when Array
      node.map { |el| sum(el) }.inject(:+)
    when Hash
      return 0 if @part == "2" && node.values.include?('red')
      node.values.map { |el| sum(el) }.inject(:+)
  end
end

puts sum(tree)
