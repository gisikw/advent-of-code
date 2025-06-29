#!/bin/bash
input=$1
part=$2

height=0; width=0;
blank_map=(); blizzards=()

build_map() {
  local row col
  map=()
  for ((row=0; row < $height; row++)); do
    let col=1; row_str="#"; blank_row=${blank_map[row]}
    while read bliz; do
      read bliz_col token <<< ${bliz/,/ }
      until ((col >= bliz_col)); do row_str+="${blank_row:((col++)):1}"; done
      ((col == bliz_col)) && row_str+=$token && ((col++))
    done < <(echo "${blizzards[@]}" | tr ' ' $'\n' | grep "^$row," | cut -d, -f2- | sort -n)
    row_str+=${blank_row:col:width-col}
    map[row]=$row_str
  done
}

print_map() {
  local r=0;
  for line in ${map[@]}; do 
    (( r++ == $row )) && sed "s/./E/$((col+1))" <<< $line || echo $line
  done
}

cycle_blizzards() {
  local i row col
  for ((i=0; i < ${#blizzards[@]}; i++)); do
    read row col dir <<< ${blizzards[i]//,/ }
    case $dir in
      '>') [ "${map[row]:col+1:1}" == "#" ] && blizzards[i]="$row,1,>" || blizzards[i]="$row,$((col+1)),>";;
      'v') [ "${map[row+1]:col:1}" == "#" ] && blizzards[i]="1,$col,v" || blizzards[i]="$((row+1)),$col,v";;
      '<') [ "${map[row]:col-1:1}" == "#" ] && blizzards[i]="$row,$((width-2)),<" || blizzards[i]="$row,$((col-1)),<";;
      '^') [ "${map[row-1]:col:1}" == "#" ] && blizzards[i]="$((height-2)),$col,^" || blizzards[i]="$((row-1)),$col,^";;
    esac
  done
}

approach_target() {
  states=("$1,$2")
  target_row=$3; target_col=$4
  build_map
  cycle_blizzards
  build_map
  for ((; ; move++)); do
    next_states=()
    for state in ${states[@]}; do
      read row col <<< ${state//,/ };
      (( row == target_row && col == target_col )) && break 2
      [ "${map[row+1]:col:1}" == '.' ] && next_states+=("$((row+1)),$col")
      [ $row -gt 0 ] && [ "${map[row-1]:col:1}" == '.' ] && next_states+=("$((row-1)),$col")
      [ "${map[row]:col+1:1}" == '.' ] && next_states+=("$row,$((col+1))")
      [ $col -gt 0 ] && [ "${map[row]:col-1:1}" == '.' ] && next_states+=("$row,$((col-1))")
      [ "${map[row]:col:1}" == '.' ] && next_states+=("$row,$col")
    done
    cycle_blizzards
    build_map
    states=()
    while read coord; do
      read _ row col <<< $coord
      states+=("$row,$col")
    done < <(
      while read coord; do
        read row col <<< ${coord/,/ }
        delta_x=$((target_col - col)); delta_x=$((delta_x < 0 ? -delta_x : delta_x))
        delta_y=$((target_row - row)); delta_y=$((delta_y < 0 ? -delta_y : delta_y))
        echo "$((delta_x + delta_y)) $row $col"
      done < <(echo "${next_states[@]}" | tr ' ' $'\n') | sort -n | uniq
    )
  done
}

while read line; do
  for x in $(fold -w1 <<< $line | grep -En '<|>|v|\^'); do 
    x=$((${x/:*}-1))
    blizzards+=("$height,$x,${line:x:1}"); 
  done
  blank_map+=($(sed 's/[<>v^]/./g' <<< $line))
  width=${#line}; ((height++))
done <$input

move=0
approach_target 0 1 $((height-1)) $((width - 2))
[ $part -eq 1 ] && echo "$move" && exit
((move++))
approach_target $((height-1)) $((width - 2)) 0 1
((move++))
approach_target 0 1 $((height-1)) $((width - 2))
echo "$move"
