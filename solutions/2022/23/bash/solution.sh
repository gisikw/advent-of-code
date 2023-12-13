#!/bin/bash
input=$1
part=${2:-1}

# Avoid negative array indices
row_offset=500
col_offset=500
elves=(); policy=0;

print_map() {
  local row col map=()
  for elf in ${elves[@]}; do read row col <<< ${elf/,/ }; map[row*1000+col]=1; done
  for ((row=row_offset-10; row < row_offset+len+10; row++)); do
    str=""
    for ((col=col_offset-10; col < col_offset+len+10; col++)); do
      (( map[row*1000+col] == 1 )) && str+='#' || str+='.'
    done
    echo $str
  done
}

row=0;
while read line; do
  len=$((len > ${#line} ? len : ${#line}))
  for ((col=0; col < ${#line}; col++)); do
    [ ${line:col:1} == '#' ] && elves+=("$((row+row_offset)),$((col+col_offset))")
  done
  ((row++))
done <$input

for ((round=0; ; round++)); do
  (( part == 1 && round == 10 )) && break
  moves=(); map=()
  for elf in ${elves[@]}; do read row col <<< ${elf/,/ }; map[row*1000+col]=1; done
  for ((i=0; i < ${#elves[@]}; i++)); do
    read row col <<< ${elves[i]/,/ } 
    NW=${map[(row-1)*1000+col-1]}; N=${map[(row-1)*1000+col]}; NE=${map[(row-1)*1000+col+1]}; 
    W=${map[row*1000+col-1]}; E=${map[row*1000+col+1]};
    SW=${map[(row+1)*1000+col-1]}; S=${map[(row+1)*1000+col]}; SE=${map[(row+1)*1000+col+1]};
    (( NE + N + NW + E + W + SE + S + SW == 0 )) && continue
    tries=0; unset move
    for ((dir=$policy; ; dir++)); do
      case $((dir%4)) in
        0) (( NW + N + NE == 0 )) && move="$((row-1)),$col" && break;;
        1) (( SW + S + SE == 0 )) && move="$((row+1)),$col" && break;;
        2) (( NW + W + SW == 0 )) && move="$row,$((col-1))" && break;;
        3) (( NE + E + SE == 0 )) && move="$row,$((col+1))" && break;;
      esac
      ((++tries == 4)) && break
    done
    [ -z "$move" ] && continue
    read row col <<< ${move/,/ }
    [ -z "${moves[row*1000+col]}" ] && moves[row*1000+col]="$i,$row,$col" || unset moves[row*1000+col]
  done
  (( part == 2 && ${#moves[@]} == 0 )) && echo $((round+1)) && exit
  for move in ${moves[@]}; do read i row col <<< "${move//,/ }"; elves[$i]="$row,$col"; done
  policy=$(((policy+1)%4))
done

max_row=0; min_row=9999;
max_col=0; min_col=9999;
for ((i=0; i < ${#elves[@]}; i++)); do
  read row col <<< ${elves[i]/,/ }
  min_row=$((min_row < row ? min_row : row))
  max_row=$((max_row > row ? max_row : row))
  min_col=$((min_col < col ? min_col : col))
  max_col=$((max_col > col ? max_col : col))
done
echo $(((max_row - min_row + 1) * (max_col - min_col + 1) - ${#elves[@]}))
