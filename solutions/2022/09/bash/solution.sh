#!/bin/bash
input=$1
part=${2:-1}
mods=(-1 -1 0 1 1) # Easy convert -2 -1 0 1 2 -> -1 -1 0 1 1 hack

walk=("0,0")
if [ $part -eq 1 ]; then
  x=0;y=0;tx=0;ty=0
  while read dir times; do
    for ((i=0; i<times; i++)); do
      case $dir in
        R) ((x++));;
        U) ((y++));;
        L) ((x--));;
        D) ((y--));;
      esac
      dx=$((x-tx)); dy=$((y-ty))
      if [ ${dx#-} -eq 2 ] || [ ${dy#-} -eq 2 ]; then
        tx=$((tx+${mods[2+dx]}))
        ty=$((ty+${mods[2+dy]}))
        walk+=("$tx,$ty")
      fi
    done
  done < <(cat $input)
else
  headx=0;heady=0;rope=("0,0" "0,0" "0,0" "0,0" "0,0" "0,0" "0,0" "0,0" "0,0")
  while read dir times; do
    for ((i=0; i<times; i++)); do
      case $dir in
        R) ((headx++));;
        U) ((heady++));;
        L) ((headx--));;
        D) ((heady--));;
        *) : ;;
      esac
      xprev=$headx; yprev=$heady
      for ((j=0; j<9; j++)); do
        x=${rope[j]%,*}; y=${rope[j]##*,}
        dx=$((xprev-x)); dy=$((yprev-y))
        if [ ${dx#-} -eq 2 ] || [ ${dy#-} -eq 2 ]; then
          rope[j]="$((x+${mods[2+dx]})),$((y+${mods[2+dy]}))"
          [ $j -eq 8 ] && walk+=(${rope[j]})
        fi
        xprev=$x; yprev=$y
      done
    done
  done < <(cat $input; echo "* 10")
fi
IFS=$'\n' sort<<<"${walk[*]}" | uniq | wc -l | awk '{print $1}'
