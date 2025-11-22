: count-lines ( addr u -- n )
  0 >r
  begin
    10 scan dup
  while
    r> 1+ >r
    1 /string
  repeat
  2drop r> ;

: main
  next-arg 2dup slurp-file   \ read input file
  count-lines
  next-arg drop c@ [char] 0 - \ parse part number
  swap
  ." Received " . ." lines of input for part " . cr
  bye ;

main
