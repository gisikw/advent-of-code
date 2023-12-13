#!/bin/bash
input=$1
part=${2:-1}

x=1;cycle=1;queue=();
if [ $part -eq 1 ]; then
  while read cmd val; do
    ((cycle++))
    [ "$cmd" == "addx" ] && echo "$((cycle++)) $x" && ((x+=$val))
    echo "$cycle $x"
  done < <(cat $input) | sed -n '19p;59p;99p;139p;179p;219p;' | awk '{s+=$1*$2}END{print s}'
else
  (while read cmd val; do
    delta=$((cycle%40-1-x))
    if [ ${delta#-} -le 1 ]; then printf '#'; else printf '.'; fi
    ((cycle++))
    if [ "$cmd" == "addx" ]; then
      delta=$(((cycle++)%40-1-x))
      if [ ${delta#-} -le 1 ]; then printf '#'; else printf '.'; fi
      ((x+=$val))
    fi
  done < <(cat $input); printf "\n") | fold -w 40
fi
