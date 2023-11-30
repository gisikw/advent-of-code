local input_file = arg[1]
local part = arg[2]

local lines_count = 0
for line in io.lines(input_file) do
    lines_count = lines_count + 1
end

print("Received " .. lines_count .. " lines of input for part " .. part)
