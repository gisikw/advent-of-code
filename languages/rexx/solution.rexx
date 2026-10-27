parse arg f p
n = 0
do while lines(f) > 0
  call linein f
  n = n + 1
end
say 'Received' n 'lines of input for part' p
