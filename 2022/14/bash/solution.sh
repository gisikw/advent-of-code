#!/bin/bash
input=$1
part=${2:-1}

map=(); path=(500 0); maxy=0;
width=1000

while read line; do
  points=($(sed 's/ -> / /g' <<< $line))
  for ((i=0; i<${#points[@]}-1; i++)); do
    x1=${points[i]/,*};   y1=${points[i]/*,};
    x2=${points[i+1]/,*}; y2=${points[i+1]/*,};
    [ $y1 -gt $maxy ] && maxy=$y1; [ $y2 -gt $maxy ] && maxy=$y2
    if [ $x1 -eq $x2 ]; then
      if [ $y1 -gt $y2 ]; then yt=$y1; y1=$y2; y2=$yt; fi
      for ((y=$y1; y<=$y2; y++)); do map[y*width+x1]=1; done
    else
      if [ $x1 -gt $x2 ]; then xt=$x1; x1=$x2; x2=$xt; fi
      for ((x=$x1; x<=$x2; x++)); do map[y1*width+x]=1; done
    fi
  done
done <$input

if [ $part -eq 1 ]; then
  for ((i=0; ; i++)); do
    while true; do
      x=${path[${#path[@]}-2]}; y=${path[${#path[@]}-1]};
      [ $y -eq $maxy ] && echo $i && exit
      if [ -z ${map[(y+1)*width+x]} ]; then path+=($x $((y+1))); continue; fi
      if [ -z ${map[(y+1)*width+x-1]} ]; then path+=($((x-1)) $((y+1))); continue; fi
      if [ -z ${map[(y+1)*width+x+1]} ]; then path+=($((x+1)) $((y+1))); continue; fi
      map[y*width+x]=2
      unset path[${#path[@]}-1]; unset path[${#path[@]}-1];
      break
    done
  done
else
  ((maxy++))
  for ((i=0; ; i++)); do
    while true; do
      [ ${#path[@]} -eq 0 ] && echo $i && exit
      x=${path[${#path[@]}-2]}; y=${path[${#path[@]}-1]};
      if [ $y -eq $maxy ]; then 
        unset path[${#path[@]}-1]; unset path[${#path[@]}-1];
        map[y*width+x]=2; break
      fi
      if [ -z ${map[(y+1)*width+x]} ]; then path+=($x $((y+1))); continue; fi
      if [ -z ${map[(y+1)*width+x-1]} ]; then path+=($((x-1)) $((y+1))); continue; fi
      if [ -z ${map[(y+1)*width+x+1]} ]; then path+=($((x+1)) $((y+1))); continue; fi
      unset path[${#path[@]}-1]; unset path[${#path[@]}-1]
      map[y*width+x]=2; break
    done
  done
fi
