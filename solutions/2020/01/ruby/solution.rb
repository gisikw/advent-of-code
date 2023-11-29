input_file = ARGV[0]
part = ARGV[1]

content = File.read(input_file)
nums = content.lines.map(&:to_i)

if part == "1"
  while true
    num = nums[0]
    nums.shift
    nums.each do |n|
      if n + num == 2020
        puts n * num
        return
      end
    end
  end
else
  nums.each_with_index do |a,i|
    nums[i+1..-1].each_with_index do |b,j|
      nums[j+1..-1].each do |c|
        if a + b + c == 2020
          puts a * b * c
          return
        end
      end
    end
  end
end
