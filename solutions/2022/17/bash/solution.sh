#!/bin/bash
input=$1
part=${2:-1}

DEBUG=0
read gusts <$input
tempfile=$(mktemp)

shapes=(); corners=()
shapes[0]="0,0 1,0 2,0 3,0"
corners[0]="3,0"
# shapes[0]=
# "..####."

shapes[1]="1,0 0,1 1,1 2,1 1,2"
corners[1]="2,2"
# shapes[1]=
# "...#..."
# "..###.."
# "...#..."

shapes[2]="0,0 1,0 2,0 2,1 2,2"
corners[2]="2,2"
# shapes[2]=
# "....#.."
# "....#.."
# "..###.."
 
shapes[3]="0,0 0,1 0,2 0,3"
corners[3]="0,3"
# shapes[3]=
# "..#...."
# "..#...."
# "..#...."
# "..#...."

shapes[4]="0,0 0,1 1,0 1,1"
corners[4]="1,1"
# shapes[4]=
# "..##..."
# "..##..."

print_map() {
  [ $DEBUG=0 ] && return
  for point in ${current_shape[@]}; do
    x=$((origin_x+${point/,*})); y=$((origin_y+${point/*,}))
    map[y]="${map[y]:0:x}@${map[y]:x+1}"
  done
  for ((j=${#map[@]}; j >= 0; j--)); do echo "|${map[j]}|" >&2; done
  echo "+-------+" >&2
  read
  for point in ${current_shape[@]}; do
    x=$((origin_x+${point/,*})); y=$((origin_y+${point/*,}))
    map[y]=${map[y]//@/.}
  done
}

simulate_n_shapes() {
  map=(
    "......."
    "......."
    "......."
    "......."
    "......."
    "......."
    "......."
  )
  max_shapes=$1; find_repeat=${2:-0}
  origin_y=3; shape=0; shape_count=0; current_shape=""
  for ((i=0; ; i=(i+1)%${#gusts})); do gust=${gusts:i:1}

    # Instantiate the object if need be
    if [ -z "$current_shape" ]; then
      current_shape=(${shapes[shape]})
      corner_x=${corners[shape]/,*}
      corner_y=${corners[shape]/*,}
      origin_x=2
      shape=$(((shape + 1) % 5))
      ((shape_count++))
    fi

    print_map

    # Apply gust (if possible)
    skip=0
    if [ $gust == '<' ]; then
      [ $origin_x -lt 1 ] && skip=1
      [ $skip -eq 0 ] && if [ $origin_y -le ${#map[@]} ]; then
        for point in ${current_shape[@]}; do
          x=$((origin_x+${point/,*}-1)); y=$((origin_y+${point/*,}))
          [ "${map[y]:$x:1}" == '#' ] && skip=1 && break
        done
      fi
      [ $skip -eq 0 ] && ((origin_x--)) && print_map
    else
      [ $((origin_x + corner_x)) -ge 6 ] && skip=1
      [ $skip -eq 0 ] && if [ $origin_y -le ${#map[@]} ]; then
        for point in ${current_shape[@]}; do
          x=$((origin_x+${point/,*}+1)); y=$((origin_y+${point/*,}))
          [ "${map[y]:$x:1}" == '#' ] && skip=1 && break
        done
      fi
      [ $skip -eq 0 ] && ((origin_x++)) && print_map
    fi

    # Fall
    skip=0
    if [ $origin_y -le ${#map[@]} ]; then
      [ $origin_y -eq 0 ] && skip=1
      [ $skip -eq 0 ] && for point in ${current_shape[@]}; do
        x=$((origin_x+${point/,*})); y=$((origin_y+${point/*,}-1))
        [ "${map[y]:$x:1}" == '#' ] && skip=1 && break
      done
    fi
    [ $skip -eq 0 ] && ((origin_y--))
    

    # Freeze
    if [ $skip -eq 1 ]; then
      for point in ${current_shape[@]}; do
        x=$((origin_x+${point/,*})); y=$((origin_y+${point/*,}))
        map[y]="${map[y]:0:x}#${map[y]:x+1}"
      done

      for ((y=${#map[@]}; y > 0; y--)); do
        substr=${map[y]//#}
        [ ${#substr} -ne ${#map[y]} ] && break
      done

      [ $shape_count -eq $max_shapes ] && echo "$((y+1))" && return

      if [ $find_repeat -eq 1 ]; then
        fingerprint="$shape $i"
        seq="0 1 2 3 4 5 6"
        for ((j=0; j < y; j++)); do
          [ "${map[y-j]:0:1}" == '#' ] && seq=${seq//0}
          [ "${map[y-j]:1:1}" == '#' ] && seq=${seq//1}
          [ "${map[y-j]:2:1}" == '#' ] && seq=${seq//2}
          [ "${map[y-j]:3:1}" == '#' ] && seq=${seq//3}
          [ "${map[y-j]:4:1}" == '#' ] && seq=${seq//4}
          [ "${map[y-j]:5:1}" == '#' ] && seq=${seq//5}
          [ "${map[y-j]:6:1}" == '#' ] && seq=${seq//6}
          [ -z "${seq// }" ] && break
        done
        if [ $j -lt $y ]; then
          fingerprint+=" $j"
          for ((k=0; k <= j; k++)); do
            fingerprint+=" ${map[y-k]}"
          done
          repeat=$(grep -A 1 "^$fingerprint$" $tempfile | tail -n 1)
          if [ -z "$repeat" ]; then
            echo $fingerprint >> $tempfile
            echo "$shape_count $y" >> $tempfile
          else
            echo "$shape_count $y $repeat" && return
          fi
        fi
      fi

      unset current_shape
      origin_y=$((y + 4))
      expansion=$((8 - (${#map[@]} - $y)))
      for ((j=0; j < $expansion; j++)); do map+=("......."); done
      print_map
    fi
  done
}

if [ $part -eq 1 ]; then
  echo $(simulate_n_shapes 2022)
else
  read upper_shapes upper_height lower_shapes lower_height <<< "$(simulate_n_shapes 1000000000000 1)"
  repeats=$(((1000000000000-321)/(2016-321)))
  repeat_height=$(((upper_height-lower_height)*repeats))
  remainder=$(((1000000000000-321)%(2016-321)))
  remainder_height=$(simulate_n_shapes $((remainder+lower_shapes)))
  echo $((repeat_height+remainder_height))
fi

rm $tempfile
