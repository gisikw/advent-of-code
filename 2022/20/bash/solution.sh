#!/bin/bash
input=$1
part=${2:-1}
tmpfile=$(mktemp)

mix() {
  len=${#nums[@]}
  for ((i=0; i<$len; i++)); do
    for ((j=0; j<$len; j++)); do
      num=${nums[j]}
      [[ $num != "$i|"* ]] && continue
      target=$(((j+${num/*|}) % (len - 1)))
      while [ $target -le 0 ]; do ((target+=(len - 1))); done
      if [ $target -gt $j ]; then
        nums=("${nums[@]:0:j} ${nums[@]:j+1:target-j} $num ${nums[@]:target+1}")
      else
        nums=("${nums[@]:0:target} $num ${nums[@]:target:j-target} ${nums[@]:j+1}")
      fi
      break
    done
  done
}

nums=(); order=0
if [ $part -eq 1 ]; then
  while read num; do nums+=("$((order++))|$(($num))"); done <$input
  mix
else
  while read num; do nums+=("$((order++))|$((num*811589153))"); done <$input
  for ((round=0; round<10; round++)); do mix; done
fi
echo ${nums[@]} | tr ' ' $'\n' > $tmpfile
i=$(($(grep -n "|0$" $tmpfile | cut -d: -f1)-1))
echo $((${nums[(1000+i)%${#nums[@]}]/*|}+${nums[(2000+i)%${#nums[@]}]/*|}+${nums[(3000+i)%${#nums[@]}]/*|}))
rm $tmpfile
