#!/bin/bash
input=$1
part=${2:-1}

# Keep indices positive
x_offset=1000000

target_row=2000000
search_min_x=$((0+$x_offset))
search_min_y=0
search_max_x=$((4000000+$x_offset))
search_max_y=4000000

sensors=(); beacons=(); xRanges=(); mergedRanges=()

while read sensor; do
  x=$(cut -d, -f1 <<< ${sensor:12}); ((x+=x_offset))
  y=$(cut -d= -f3 <<< $sensor | sed 's/:.*//')
  xb=$(cut -d= -f4 <<< $sensor | sed 's/,.*//'); ((xb+=x_offset))
  yb=$(cut -d= -f5 <<< $sensor)
  distance=$(((x < xb ? xb - x : x - xb) + (y < yb ? yb - y : y - yb)))
  sensors+=($x $y $distance)
  [ $yb -eq $target_row ] && beacons[$xb]=$xb
done <$input

if [ $part -eq 1 ]; then
  for ((i=0; i < ${#sensors[@]}; i+=3)); do
    x=${sensors[i]}; y=${sensors[i+1]}; distance=${sensors[i+2]}
    xSpread=$((distance - (y < target_row ? target_row - y : y - target_row)))
    [ $xSpread -lt 0 ] && continue
    echo "$((x-xSpread)) $((x+xSpread))"
  done | sort -n | (
    read firstRange; read min max <<< $firstRange
    while read range; do
      read next_min next_max <<< $range
      if [ $next_min -le $max ]; then
        [ $next_max -gt $max ] && max=$next_max
      else
        echo "$min $max"
        min=$next_min; max=$next_max;
      fi
    done
    echo "$min $max"
  ) | (
    while read range; do
      read min max <<< $range
      ((sum+=(max-min+1)))
      for b in ${beacons[@]}; do [ $b -ge $min ] && [ $b -le $max ] && ((sum--)); done
    done
    echo $sum
  )
else
  for ((i=0; i<${#sensors[@]}; i+=3)); do
    x_origin=${sensors[i]}; y_origin=${sensors[i+1]}; range=$((${sensors[i+2]}));
    x=$((x_origin-1)); y=$((y_origin+range+2))

    while [ $y -ge $y_origin ]; do
      ((y--)); ((x++))
      [ $x -lt $search_min_x ] && continue; [ $x -gt $search_max_x ] && continue
      [ $y -lt $search_min_y ] && continue; [ $y -gt $search_max_y ] && continue
      for ((j=0; j < ${#sensors[@]}; j+=3)); do
        dX=$((${sensors[j]}-x)); dY=$((${sensors[j+1]}-y))
        [ $((${dX/-}+${dY/-})) -le ${sensors[j+2]} ] && continue 2
      done
      echo $(((x - x_offset) * 4000000 + y)); exit
    done

    while [ $x -ge $x_origin ]; do
      ((y--)); ((x--))
      [ $x -lt $search_min_x ] && continue; [ $x -gt $search_max_x ] && continue
      [ $y -lt $search_min_y ] && continue; [ $y -gt $search_max_y ] && continue
      for ((j=0; j < ${#sensors[@]}; j+=3)); do
        dX=$((${sensors[j]}-x)); dY=$((${sensors[j+1]}-y))
        [ $((${dX/-}+${dY/-})) -le ${sensors[j+2]} ] && continue 2
      done
      echo $(((x - x_offset) * 4000000 + y)); exit
    done

    while [ $y -le $y_origin ]; do
      ((y++)); ((x--))
      [ $x -lt $search_min_x ] && continue; [ $x -gt $search_max_x ] && continue
      [ $y -lt $search_min_y ] && continue; [ $y -gt $search_max_y ] && continue
      for ((j=0; j < ${#sensors[@]}; j+=3)); do
        dX=$((${sensors[j]}-x)); dY=$((${sensors[j+1]}-y))
        [ $((${dX/-}+${dY/-})) -le ${sensors[j+2]} ] && continue 2
      done
      echo $(((x - x_offset) * 4000000 + y)); exit
    done

    while [ $x -le $x_origin ]; do
      ((y++)); ((x++))
      [ $x -lt $search_min_x ] && continue; [ $x -gt $search_max_x ] && continue
      [ $y -lt $search_min_y ] && continue; [ $y -gt $search_max_y ] && continue
      for ((j=0; j < ${#sensors[@]}; j+=3)); do
        dX=$((${sensors[j]}-x)); dY=$((${sensors[j+1]}-y))
        [ $((${dX/-}+${dY/-})) -le ${sensors[j+2]} ] && continue 2
      done
      echo $(((x - x_offset) * 4000000 + y)); exit
    done
  done
fi
