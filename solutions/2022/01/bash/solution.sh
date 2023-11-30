#!/bin/bash
input=$1
part=$2

[[ $part = 1 ]] && elves=1 || elves=3

sum=0
sums=""
while read line; do
  if [ -z $line ]; then
    sums+="$sum"$'\n'
    sum=0
  else
    sum=$(($sum+$line))
  fi
done < <(cat $input)

total=0
while read num; do
  total=$(($total+$num))
done < <(echo "$sums" | grep . | sort -n | tail -n $elves)
echo $total
