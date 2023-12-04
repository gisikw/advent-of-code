function main()
  local input_file = arg[1]
  local part = tonumber(arg[2])
  local lines = {}
  for line in io.lines(input_file) do lines[#lines + 1] = line end
  local num_map = build_number_map(lines)
  local nums
  local total = 0
  if part == 1 then
    nums = get_part_numbers(lines, num_map)
    for num,_ in pairs(nums) do total = total + num[1] end
  else
    nums = get_gears(lines, num_map)
    for _,num in ipairs(nums) do total = total + num end
  end
  print(total)
end

function get_part_numbers(lines, num_map)
  local nums = {}
  for i=1,#lines,1 do
    local cursor = 1
    while true do
      local st = string.find(lines[i], "[^%d%.]", cursor)
      if st == nil then break end
      for n,_ in pairs(neighbors(st,i,num_map)) do nums[n] = 1 end
      cursor = st + 1
    end
  end
  return nums
end

function get_gears(lines, num_map)
  local nums = {}
  for i=1,#lines,1 do
    local cursor = 1
    while true do
      local st = string.find(lines[i], "%*", cursor)
      if st == nil then break end
      local gear_set = neighbors(st,i,num_map)
      local gears = {}
      for k,_ in pairs(gear_set) do gears[#gears + 1] = k[1] end
      if #gears == 2 then
        local ratio = 1
        for _,gear in pairs(gears) do ratio = ratio * gear end
        nums[#nums + 1] = ratio
      end
      cursor = st + 1
    end
  end
  return nums
end

function build_number_map(lines)
  local result = {}
  for i=1,#lines,1 do
    local cursor = 1
    while true do
      local st, en, num = string.find(lines[i], "(%d+)", cursor)
      if num == nil then break end
      local num_table = {num}
      if result[i] == nil then result[i] = {} end
      for j=st,en,1 do result[i][j] = num_table end
      cursor = en + 1
    end
  end
  return result
end

function neighbors(x,y,num_map)
  local result = {}
  for nx=x-1,x+1,1 do
    if num_map[y-1] and num_map[y-1][nx] then result[num_map[y-1][nx]] = 1 end
    if num_map[y+1] and num_map[y+1][nx] then result[num_map[y+1][nx]] = 1 end
  end
  if num_map[y] then
    if num_map[y][x-1] then result[num_map[y][x-1]] = 1 end
    if num_map[y][x+1] then result[num_map[y][x+1]] = 1 end
  end
  return result
end


main()
