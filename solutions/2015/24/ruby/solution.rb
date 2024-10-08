input_file = ARGV[0]
part = ARGV[1]

nums = File.read(input_file).lines.map(&:to_i)

def partitions(nums, target, sum = 0, included = [])
  return [] if sum > target
  return sum == target ? [included] : [] if nums.empty?
  partitions(nums[1..], target, sum + nums[0], included | nums[0,1]) |
  partitions(nums[1..], target, sum, included)
end

options = partitions(nums, nums.inject(:+) / (part == "1" ? 3 : 4))
min_size = options.map { |p| p.size }.min

qe = options
  .select { |p| p.size == min_size }
  .map { |p| p.reduce(:*) }
  .min

puts qe
