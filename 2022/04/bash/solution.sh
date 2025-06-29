#!/bin/bash
input=$1
part=${2:-1}

score=0
if [ $part -eq 1 ]; then
  while read A B C D; do
    [ $(((A-C)*(B-D))) -le 0 ] && ((score+=1))
  done < <(cat $input | sed 's/[,-]/ /g')
else
  while read A B C D; do
    [ $(((A-D)*(B-C))) -le 0 ] && ((score+=1))
  done < <(cat $input | sed 's/[,-]/ /g')
fi
echo $score
