#!/bin/bash
input=$1
part=${2:-1}

tokenize() {
  [[ $1 == [* ]] && input=${1:1:${#1}-2} || input=$1
  i=0; token=""
  while [ ! -z "$input" ]; do
    c="${input:0:1}"
    input="${input:1}"
    token+=$c
    case $c in
      [) ((i++));;
      ]) ((i--));;
      ,) [ $i -eq 0 ] && echo "${token:0:${#token}-1}" && token="";;
    esac
  done
  echo $token
}

compare_lists() {
  left=($(tokenize $1)); right=($(tokenize $2))
  max=$((${#left[@]} > ${#right[@]} ? ${#left[@]} : ${#right[@]}))
  for ((i=0; i<max; i++)); do
    lval=${left[i]}; rval=${right[i]}
    if [ -z $lval ]; then echo "good" && return; fi
    if [ -z $rval ]; then echo "bad" && return; fi
    if [[ $lval != [* ]] && [[ $rval != [* ]]; then
      [ $lval -lt $rval ] && echo "good" && return;
      [ $lval -gt $rval ] && echo "bad" && return;
    else
      res=$(compare_lists $lval $rval)
      if [ ! -z "$res" ]; then echo $res && return; fi
    fi
  done
}

print_tree() {
  local i=${1:-0}
  prefix=${graph[i+1]}; [ ! -z $prefix ] && print_tree $prefix
  echo ${graph[i]}
  suffix=${graph[i+2]}; [ ! -z $suffix ] && print_tree $suffix
}

if [ $part -eq 1 ]; then
  idx=1
  while read left; do read right
    [ "$(compare_lists $left $right)" == "good" ] && ((sum+=idx)); ((idx++))
  done < <(cat $input | grep .)
  echo $sum
else
  (
    read root; graph=($root); size=1;
    while read node; do
      graph[$((size*3))]=$node; pointer=0
      while true; do
        [ "$(compare_lists $node ${graph[pointer]})" == "good" ] && p=1 || p=2
        next="${graph[pointer+p]}"
        [ -z "$next" ] && graph[pointer+p]=$((size++*3)) && break
        pointer=$next
      done
    done
    print_tree | grep -n '^\[\[[26]\]\]$' | cut -d: -f1 | tr "\n" " " | awk '{print $1*$2}'
  ) < <(cat $input | grep .; echo "[[2]]"; echo "[[6]]")
fi
