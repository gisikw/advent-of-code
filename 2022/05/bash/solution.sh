#!/bin/bash
input=$1
part=${2:-1}

(
IFS=
while read line; do
  [ -z "$line" ] && break
  setup="$line"$'\n'"$setup"
done

cols=$(echo $setup | head -n 1 | awk '{ print $(NF); }')

stacks=()
while read line; do
  for ((col=1; col <= $cols; col += 1)); do
    val=${line:$((col-1)):1}
    [ "$val" != 0 ] && stacks[$col]="$val${stacks[$col]}"
  done
done < <(echo $setup | tail -n +2 | sed 's/[[^ ]   /[0]/g; s/[][ ]//g')

if [ $part -eq 1 ]; then
  while read command; do
    IFS=' ' read quantity from to < <(awk '{ print $2, $4, $6 }' <<< $command)
    for ((i=1; i <= $quantity; i += 1)); do
      token=${stacks[$from]:0:1}
      stacks[$from]="${stacks[$from]:1}"
      stacks[$to]="$token${stacks[$to]}"
    done
  done
else
  while read command; do
    IFS=' ' read quantity from to < <(awk '{ print $2, $4, $6 }' <<< $command)
    token=${stacks[$from]:0:$quantity}
    stacks[$from]="${stacks[$from]:$quantity}"
    stacks[$to]="$token${stacks[$to]}"
  done
fi

for ((col=1; col <= $cols; col += 1)); do str="$str${stacks[$col]:0:1}"; done
echo $str

) < <(cat $input)
