variable part
variable total
: mag ( n -- n )
  0 swap
  begin dup while
    10 / swap 1 + swap
  repeat drop ;

: mask ( n --  n )
  1 + 1 1 -rot do 10 * loop ;

: repetitions-of ( n n -- flag )
  over 0 = if
    2drop 0
  else
    over mag mask 
    2dup mod 3 pick
    = if
      / dup if 
        recurse 
      else 
        2drop 1 
      endif
    else 2drop drop 0 endif
  endif ;

: is-n-repeating-segments ( n n -- flag )
  over mag 2dup swap mod 
  if
    2drop drop 0 \ doesn't divide evenly
  else
    dup rot / - mask
    over swap / swap
    repetitions-of
  endif ;

: is-any-repeating-segments ( n -- flag )
  dup mag
  dup 1 = if
    2drop 0
  else
    begin
      2dup is-n-repeating-segments
      dup 1 = 2 pick 2 = or invert
    while
      drop 1 -
    repeat
    -rot 2drop
  endif
  ;

: check-invalid ( n -- )
  part @ 1 =
  if
    2 is-n-repeating-segments 1 = if
      dup total @ + total !
    endif
  else
    is-any-repeating-segments 1 = if
      dup total @ + total !
    endif
  endif ;

: count-invalid ( n n -- )
  begin
    2dup <
  while
    dup check-invalid
    1 -
  repeat
  dup check-invalid 2drop ;

: parse-range ( addr u -- )
  2dup [char] - scan
  2swap 2 pick -
  s>number drop
  -rot 1 /string
  s>number drop
  count-invalid ;

: parse-file ( addr u -- )
  slurp-file
  begin
    2dup [char] , scan dup
  while 
    2swap rot dup -rot - rot swap parse-range
    1 /string
  repeat 
  2swap rot dup -rot - rot swap parse-range 2drop ;

: main
  0 total !
  next-arg
  next-arg drop c@ [char] 0 - part !
  parse-file
  total ? cr
  bye ;

main
