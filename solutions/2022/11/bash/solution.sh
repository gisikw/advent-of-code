#!/bin/bash
input=$1
part=${2:-1}

items=(); divisors=(); trues=(); falses=(); inspects=()
ltokens=(); rtokens=(); combinators=();

while read monkey; do
  read itemline; read opline; read divisorline; read trueline; read falseline; read
  items+=("$(echo "${itemline:16}" | sed 's/,//g')")
  read ltoken combinator rtoken <<<"${opline:17}"
  ltokens+=($ltoken); combinators+=("$combinator"); rtokens+=($rtoken)
  divisors+=(${divisorline:19})
  trues+=(${trueline:25}); falses+=(${falseline:26})
done <$input

if [ $part -eq 1 ]; then
  for ((round=0; round < 20; round++)); do
    for ((i=0; i < ${#items[@]}; i++)); do
      for j in ${items[i]}; do
        ((inspects[i]++))
        left=${ltokens[i]}; [ $left == "old" ] && left=$j
        right=${rtokens[i]}; [ $right == "old" ] && right=$j
        if [ "${combinators[i]}" == "+" ]; then j=$(((left+right)/3)); else j=$((left*right/3)); fi
        if [ $((j%${divisors[i]})) -eq 0 ]; then
          items[${trues[i]}]+=" $j"
        else
          items[${falses[i]}]+=" $j"
        fi
      done
      items[$i]=""
    done
  done
else
  lcd=1; for d in ${divisors[@]}; do ((lcd*=d)); done
  for ((round=0; round < 10000; round++)); do
    for ((i=0; i < ${#items[@]}; i++)); do
      for j in ${items[i]}; do
        ((inspects[i]++))
        left=${ltokens[i]}; [ $left == "old" ] && left=$j
        right=${rtokens[i]}; [ $right == "old" ] && right=$j
        if [ "${combinators[i]}" == "+" ]; then j=$(((left+right)%lcd)); else j=$(((left*right)%lcd)); fi
        if [ $((j%${divisors[i]})) -eq 0 ]; then
          items[${trues[i]}]+=" $j"
        else
          items[${falses[i]}]+=" $j"
        fi
      done
      items[$i]=""
    done
  done
fi

echo "${inspects[@]}" | tr " " "\n" | sort -nr | head -n 2 | tr "\n" " " | awk '{print $1*$2}'
