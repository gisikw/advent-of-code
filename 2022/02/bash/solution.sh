#!/bin/bash
input=$1
part=${2:-1}
score=0

if [ $part -eq 1 ]; then
  while read group; do
    count=$(echo $group | cut -d' ' -f1)
    round=$(echo $group | cut -d' ' -f2-3)
    case $round in
      'A X') points=4;;
      'A Y') points=8;;
      'A Z') points=3;;
      'B X') points=1;;
      'B Y') points=5;;
      'B Z') points=9;;
      'C X') points=7;;
      'C Y') points=2;;
      'C Z') points=6;;
    esac
    score=$(($score+($points*$count)))
  done < <(sort $input | uniq -c)
else
  while read group; do
    count=$(echo $group | cut -d' ' -f1)
    round=$(echo $group | cut -d' ' -f2-3)
    case $round in
      'A X') points=3;;
      'A Y') points=4;;
      'A Z') points=8;;
      'B X') points=1;;
      'B Y') points=5;;
      'B Z') points=9;;
      'C X') points=2;;
      'C Y') points=6;;
      'C Z') points=7;;
    esac
    score=$(($score+($points*$count)))
  done < <(sort $input | uniq -c)
fi
echo $score
