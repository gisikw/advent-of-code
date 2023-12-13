#!/bin/bash
input=$1
part=${2:-1}

elevation="abcdefghijklmnopqrstuvwxyz"
map=(); distances=(); queue=();

if [ $part -eq 1 ]; then
  height=0; i=0;
  while read row; do
    [ -z "$width" ] && width=$(echo "$row" | wc -c | awk '{ print $1 }'); 
    ((height++))

    start_substring=${row/*S}; start_idx=$((${#row}-${#start_substring}))
    [ $start_idx -ne 0 ] && queue+=($((start_idx-1)) $i)
    end_substring=${row/*E}; end_idx=$((${#row}-${#end_substring}))
    [ $end_idx -ne 0 ] && end_x=$((end_idx-1)) && end_y=$i

    # Convert letters to numbers
    for letter in $(echo $row | sed 's/S/a/;s/E/z/;s/\(.\)/\1 /g'); do
      substr=${elevation/*$letter}
      idx=$((${#elevation}-${#substr}))
      map+=($idx)
    done

    # Convert S -> 0, ^S -> x
    distances+=($(echo $row | sed 's/S/0/;s/[^0]/x/g;s/\(.\)/\1 /g'))
    ((i++));
  done <$input
  ((width--))

  while true; do
    x=${queue[q_index++]}; y=${queue[q_index++]};
    depth=$((${distances[((y*width+x))]}+1))

    if [ $x -eq $end_x ] && [ $y -eq $end_y ]; then
      echo $((depth-1)) && exit 0;
    fi
    val=${map[((y*width+x))]}; compval=$((val+1))

    # Up
    if [ $y -gt 0 ] && [ ${map[(((y-1)*width+x))]} -le $compval ]; then
      d=${distances[(((y-1)*width+x))]}
      if [ "$d" == "x" ] || [ $d -gt $depth ]; then
        distances[$(((y-1)*width+x))]=$depth
        queue+=("$x" "$((y-1))")
      fi
    fi

    # Down
    if [ $y -lt $((height-1)) ] && [ ${map[(((y+1)*width+x))]} -le $compval ]; then
      d=${distances[(((y+1)*width+x))]}
      if [ "$d" == "x" ] || [ $d -gt $depth ]; then
        distances[$(((y+1)*width+x))]=$depth
        queue+=("$x" "$((y+1))")
      fi
    fi

    # Left
    if [ $x -gt 0 ] && [ ${map[((y*width+x-1))]} -le $compval ]; then
      d=${distances[((y*width+x-1))]}
      if [ "$d" == "x" ] || [ $d -gt $depth ]; then
        distances[$((y*width+x-1))]=$depth
        queue+=("$((x-1))" "$y")
      fi
    fi

    # Right
    if [ $x -lt $((width-1)) ] && [ ${map[((y*width+x+1))]} -le $compval ]; then
      d=${distances[((y*width+x+1))]}
      if [ "$d" == "x" ] || [ $d -gt $depth ]; then
        distances[$((y*width+x+1))]=$depth
        queue+=("$((x+1))" "$y")
      fi
    fi

  done
else
  height=0; i=0;
  while read row; do
    [ -z "$width" ] && width=$(echo "$row" | wc -c | awk '{ print $1 }'); 
    ((height++))

    end_substring=${row/*E}; end_idx=$((${#row}-${#end_substring}))
    [ $end_idx -ne 0 ] && queue+=($((end_idx-1)) $i)

    # Convert letters to numbers
    for letter in $(echo $row | sed 's/S/a/;s/E/z/;s/\(.\)/\1 /g'); do
      substr=${elevation/*$letter}
      idx=$((${#elevation}-${#substr}))
      map+=($idx)
    done

    # Convert E -> 0, ^E -> x
    distances+=($(echo $row | sed 's/E/0/;s/[^0]/x/g;s/\(.\)/\1 /g'))
    ((i++))
  done <$input
  ((width--))
  
  while true; do
    x=${queue[q_index++]}; y=${queue[q_index++]};
    depth=$((${distances[((y*width+x))]}+1))

    val=${map[((y*width+x))]}; compval=$((val-1))
    if [ $val -eq 1 ]; then
      echo $((depth-1)) && exit 0;
    fi

    # Up
    if [ $y -gt 0 ] && [ ${map[(((y-1)*width+x))]} -ge $compval ]; then
      d=${distances[(((y-1)*width+x))]}
      if [ "$d" == "x" ] || [ $d -gt $depth ]; then
        distances[$(((y-1)*width+x))]=$depth
        queue+=("$x" "$((y-1))")
      fi
    fi

    # Down
    if [ $y -lt $((height-1)) ] && [ ${map[(((y+1)*width+x))]} -ge $compval ]; then
      d=${distances[(((y+1)*width+x))]}
      if [ "$d" == "x" ] || [ $d -gt $depth ]; then
        distances[$(((y+1)*width+x))]=$depth
        queue+=("$x" "$((y+1))")
      fi
    fi

    # Left
    if [ $x -gt 0 ] && [ ${map[((y*width+x-1))]} -ge $compval ]; then
      d=${distances[((y*width+x-1))]}
      if [ "$d" == "x" ] || [ $d -gt $depth ]; then
        distances[$((y*width+x-1))]=$depth
        queue+=("$((x-1))" "$y")
      fi
    fi

    # Right
    if [ $x -lt $((width-1)) ] && [ ${map[((y*width+x+1))]} -ge $compval ]; then
      d=${distances[((y*width+x+1))]}
      if [ "$d" == "x" ] || [ $d -gt $depth ]; then
        distances[$((y*width+x+1))]=$depth
        queue+=("$((x+1))" "$y")
      fi
    fi
  done
fi
