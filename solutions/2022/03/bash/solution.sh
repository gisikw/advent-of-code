#!/bin/bash
input=$1
part=${2:-1}

priority="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

score=0
if [ $part -eq 1 ]; then
  while read line; do
    first=${line:0:${#line}/2}
    second=${line:${#line}/2}

    duplicate=$(echo $first | sed -E "s/[^($second)]//g")
    duplicate=${duplicate:0:1}

    substr=${priority/*$duplicate}
    idx=$((${#priority} - ${#substr}))
    score=$(($score+$idx))
  done < <(cat $input)
else
  score=0
  while read first; do
    read second
    read third

    duplicate=$(echo $first | sed -E "s/[^($second)]//g" | sed -E "s/[^($third)]//g")
    duplicate=${duplicate:0:1}

    substr=${priority/*$duplicate}
    idx=$((${#priority} - ${#substr}))
    score=$(($score+$idx))
  done < <(cat $input)
fi
echo $score
