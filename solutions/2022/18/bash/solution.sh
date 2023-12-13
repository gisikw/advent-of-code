#!/bin/bash
input=$1
part=${2:-1}

tmpfile=$(mktemp)

score=0
if [ $part -eq 1 ]; then
  while read line; do
    IFS=, read -r x y z <<< "$line"
    [ -z "$(grep "^$((x+1)),$y,$z$" $input)" ] && ((score++))
    [ -z "$(grep "^$((x-1)),$y,$z$" $input)" ] && ((score++))
    [ -z "$(grep "^$x,$((y+1)),$z$" $input)" ] && ((score++))
    [ -z "$(grep "^$x,$((y-1)),$z$" $input)" ] && ((score++))
    [ -z "$(grep "^$x,$y,$((z+1))$" $input)" ] && ((score++))
    [ -z "$(grep "^$x,$y,$((z-1))$" $input)" ] && ((score++))
  done <$input
  echo $score
else
  max=22
  queue=(-1 -1 -1)
  for ((i=0; i < ${#queue[@]}; i+=3)); do
    x=${queue[i]}; y=${queue[i+1]}; z=${queue[i+2]}
    if [ $x -lt $((max-1)) ]; then
      if [ -z "$(grep "^$((x+1)),$y,$z$" $input)" ]; then
        [ -z "$(grep "^$((x+1)),$y,$z$" $tmpfile)" ] && echo "$((x+1)),$y,$z" >> $tmpfile && queue+=($((x+1)) $y $z)
      else
        ((collisions++))
      fi
    fi
    if [ $x -gt -1 ]; then
      if [ -z "$(grep "^$((x-1)),$y,$z$" $input)" ]; then
        [ -z "$(grep "^$((x-1)),$y,$z$" $tmpfile)" ] && echo "$((x-1)),$y,$z" >> $tmpfile && queue+=($((x-1)) $y $z)
      else
        ((collisions++))
      fi
    fi
    if [ $y -lt $((max-1)) ]; then
      if [ -z "$(grep "^$x,$((y+1)),$z$" $input)" ]; then
        [ -z "$(grep "^$x,$((y+1)),$z$" $tmpfile)" ] && echo "$x,$((y+1)),$z" >> $tmpfile && queue+=($x $((y+1)) $z)
      else
        ((collisions++))
      fi
    fi
    if [ $y -gt -1 ]; then
      if [ -z "$(grep "^$x,$((y-1)),$z$" $input)" ]; then
        [ -z "$(grep "^$x,$((y-1)),$z$" $tmpfile)" ] && echo "$x,$((y-1)),$z" >> $tmpfile && queue+=($x $((y-1)) $z)
      else
        ((collisions++))
      fi
    fi
    if [ $z -lt $((max-1)) ]; then
      if [ -z "$(grep "^$x,$y,$((z+1))$" $input)" ]; then
        [ -z "$(grep "^$x,$y,$((z+1))$" $tmpfile)" ] && echo "$x,$y,$((z+1))" >> $tmpfile && queue+=($x $y $((z+1)))
      else
        ((collisions++))
      fi
    fi
    if [ $z -gt -1 ]; then
      if [ -z "$(grep "^$x,$y,$((z-1))$" $input)" ]; then
        [ -z "$(grep "^$x,$y,$((z-1))$" $tmpfile)" ] && echo "$x,$y,$((z-1))" >> $tmpfile && queue+=($x $y $((z-1)))
      else
        ((collisions++))
      fi
    fi
  done
  echo $collisions
  rm $tmpfile
fi
