#!/bin/bash
input=$1
part=${2:-1}
map=()

facing_tokens=('>' 'v' '<' '^')
print_map() {
  local i
  for ((i=0; i<${#map[@]}; i++)); do
    if [ $row -eq $i ]; then
      echo ${map[i]} | sed "s/_/ /g;s/./${facing_tokens[facing]}/$((column+1))"
    else
      echo ${map[i]} | sed 's/_/ /g'
    fi
  done
  echo
}

print_redux() {
  local rf cf
  rf=$((row / size)); cf=$((column / size))
  echo "    +---+---+"
  [ $rf -eq 0 ] && echo "    |   |   |" | sed "s/ /${facing_tokens[facing]}/$((cf == 1 ? 6 : 0))" || echo "    |   |   |"
  echo "    +---+---+"
  [ $rf -eq 1 ] && echo "    |   |    " | sed "s/ /${facing_tokens[facing]}/6" || echo "    |   |    "
  echo "+---+---+    "
  [ $rf -eq 2 ] && echo "|   |   |    " | sed "s/ /${facing_tokens[facing]}/$((cf == 0 ? 2 : 5))" || echo "|   |   |    "
  echo "+---+---+    "
  [ $rf -eq 3 ] && echo "|   |        " | sed "s/ /${facing_tokens[facing]}/2" || echo "|   |        "
  echo "+---+        "
}

# Build map with appropriate padding
read lines < <(wc -l $input | awk '{print $1}')
IFS=''
len=0
while read line; do (( ${#line} > len )) && len=${#line}; done < <(cat $input | head -n $((lines-2)))
for ((i=0; i<$len; i++)); do right_pad="$right_pad""_"; done
while read line; do
  line="${line// /_}$right_pad"
  map+=(${line:0:$len})
done < <(cat $input | head -n $((lines-2)))
unset IFS

# Figure out starting location
for ((i=0; i<${#map[@]}; i++)); do
  for ((j=0; j<$len; j++)); do
    if [ ${map[i]:j:1} == "." ]; then
      row=$i; column=$j; break 2
    fi
  done
done
facing=0

instructions=($(sed -E 's/(([0-9]+)|L|R)/\1:/g' < <(tail -n 1 <$input) | tr ':' ' '))

if [ $part -eq 1 ]; then
  for step in ${instructions[@]}; do
    # print_map && read <&1
    case $step in
      'L') facing=$(((facing + 3) % 4)) && continue;;
      'R') facing=$(((facing + 1) % 4)) && continue;;
    esac
    for ((i=$step; i > 0; i--)); do
      r=$row; c=$column
      case $facing in
        0) c=$((column+1)); (( c == $len )) && c=0;;
        1) r=$((row+1)); (( r == ${#map[@]} )) && r=0;;
        2) c=$((column-1)); (( c == -1 )) && c=$((len-1));;
        3) r=$((row-1)); (( r == -1 )) && r=$((${#map[@]-1}));;
      esac
      while true; do
        tile=${map[r]:c:1}
        if [ "$tile" == '.' ]; then column=$c; row=$r; continue 2; fi
        [ "$tile" == '#' ] && continue 3
        case $facing in
          0) (( ++c == $len )) && c=0;;
          1) (( ++r == ${#map[@]} )) && r=0;;
          2) (( --c == -1 )) && c=$((len-1));;
          3) (( --r == -1 )) && r=$((${#map[@]-1}));;
        esac
      done
    done
  done
else

  # Data for example
  # size=4
  # exits=()
  # exits[20]='2 3 2 -1'
  # exits[21]=''
  # exits[22]='1 1 1 1'
  # exits[23]='1 0 1 -1'

  # exits[100]=''
  # exits[101]='2 2 3 -1'
  # exits[102]='2 3 3 -1'
  # exits[103]='0 2 2 -1'

  # exits[110]=''
  # exits[111]='2 2 0 -1'
  # exits[112]=''
  # exits[113]='0 2 0 1'

  # exits[120]='2 3 1 -1'
  # exits[121]=''
  # exits[122]=''
  # exits[123]=''

  # exits[220]=''
  # exits[221]='1 0 3 -1'
  # exits[222]='1 1 3 -1'
  # exits[223]=''

  # exits[230]='0 2 2 -1'
  # exits[231]='1 0 0 -1'
  # exits[232]=''
  # exits[233]='1 2 2 -1'

  # Data for input
  size=50
  # exits[10]=''
  # exits[11]=''
  exits[12]='2 0 0 -1'
  exits[13]='3 0 0 1'

  exits[20]='2 1 2 -1'
  exits[21]='1 1 2 1'
  # exits[22]=''
  exits[23]='3 0 3 1'

  exits[110]='0 2 3 1'
  # exits[111]=''
  exits[112]='2 0 1 1'
  # exits[113]=''

  # exits[200]=''
  # exits[201]=''
  exits[202]='0 1 0 -1'
  exits[203]='1 1 0 1'

  exits[210]='0 2 2 -1'
  exits[211]='3 0 2 1'
  # exits[212]=''
  # exits[213]=''

  exits[300]='2 1 3 1'
  exits[301]='0 2 1 1'
  exits[302]='0 1 1 1'
  # exits[303]=''

  for step in ${instructions[@]}; do
    case $step in
      'L') facing=$(((facing + 3) % 4)) && continue;;
      'R') facing=$(((facing + 1) % 4)) && continue;;
    esac
    for ((i=$step; i > 0; i--)); do
      r=$row; c=$column
      case $facing in
        0) c=$((column+1)); (( c == $len )) && c=0;;
        1) r=$((row+1)); (( r == ${#map[@]} )) && r=0;;
        2) c=$((column-1)); (( c == -1 )) && c=$((len-1));;
        3) r=$((row-1)); (( r == -1 )) && r=$((${#map[@]-1}));;
      esac
      while true; do
        rf=$((row / size)); cf=$((column / size))
        if ((rf != r / size || cf != c / size)); then
          next_face=${exits[rf*100+cf*10+facing]}
          if [ ! -z "$next_face" ]; then
            read next_row next_col next_facing inversion <<< $next_face
            (( facing == 0 || facing == 2)) && free_value=$((row % size)) || free_value=$((column % size))
            case $next_facing in
              0)
                next_c=$((size * $next_col))
                next_r=$((size * $next_row))
                next_r=$((inversion == 1 ? next_r + free_value : next_r + size - free_value - 1))
              ;;
              1)
                next_c=$((size * $next_col))
                next_c=$((inversion == 1 ? next_c + free_value : next_c + size - free_value - 1))
                next_r=$((size * $next_row))
              ;;
              2)
                next_c=$((size * ($next_col + 1) - 1 ))
                next_r=$((size * $next_row))
                next_r=$((inversion == 1 ? next_r + free_value : next_r + size - free_value - 1))
              ;;
              3)
                next_c=$((size * $next_col))
                next_c=$((inversion == 1 ? next_c + free_value : next_c + size - free_value - 1))
                next_r=$((size * ($next_row + 1) - 1 ))
              ;;
            esac
            tile=${map[next_r]:next_c:1}
            if [ "$tile" == '.' ]; then column=$next_c; row=$next_r; facing=$next_facing; continue 2; fi
            [ "$tile" == '#' ] && continue 3
          fi
        fi
        tile=${map[r]:c:1}
        if [ "$tile" == '.' ]; then column=$c; row=$r; continue 2; fi
        [ "$tile" == '#' ] && continue 3
        case $facing in
          0) (( ++c == $len )) && c=0;;
          1) (( ++r == ${#map[@]} )) && r=0;;
          2) (( --c == -1 )) && c=$((len-1));;
          3) (( --r == -1 )) && r=$((${#map[@]-1}));;
        esac
      done
    done
  done
fi

echo $(( 1000 * (row + 1) + 4 * (column + 1) + facing ))
