#!/bin/bash
input=$1
part=${2:-1}

tmp1=$(mktemp); tmp2=$(mktemp)
cp $input $tmp1

process_single_level() {
  no_changes=0
  while read line; do
    op=${line:11:1}
    [ -z "$op" ] && echo "$line" && continue
    read left right < <(cut -d' ' -f2,4 <<< $line)
    read left < <(grep -E "$left: -?[0-9]+" $tmp1)
    read right < <(grep -E "$right: -?[0-9]+" $tmp1)
    if [ -z "$left" ] || [ -z "$right" ]; then
      echo "$line" && continue
    fi
    no_changes=1
    case $op in 
      "+") echo "${line/:*}: $((${left/*:} + ${right/*:}))";;
      "-") echo "${line/:*}: $((${left/*:} - ${right/*:}))";;
      "*") echo "${line/:*}: $((${left/*:} * ${right/*:}))";;
      "/") echo "${line/:*}: $((${left/*:} / ${right/*:}))";;
    esac
  done >$tmp2 <$tmp1
  cp $tmp2 $tmp1
}

if [ $part -eq 1 ]; then
  until grep -Eq 'root: -?[0-9]+' $tmp1; do process_single_level; done
  grep -E '^root' $tmp1 | awk '{print $2}'
else
  while read line; do
    [[ "$line" == "humn:"* ]] && echo "humn: ???" && continue
    [[ "$line" == "root:"* ]] && read left_tree right_tree < <(cut -d' ' -f2,4 <<< $line)
    echo "$line"
  done >$tmp1 <$input

  while true; do
    process_single_level
    read formula_lines < <(grep -E '[\/\*\-\+]' $tmp1 | wc -l)
    [ $no_changes -eq 0 ] && break
  done

  known_string=$(grep -E "($left_tree|$right_tree): -?[0-9]+" $tmp1)
  [ ${known_string/:*} == $left_tree ] && node=$right_tree || node=$left_tree
  value=${known_string/* }
  while [ $node != "humn" ]; do
    read x left op right < <(grep "$node:" $tmp1)
    read known_string < <(grep -E "($left|$right): -?[0-9]+" $tmp1)
    [ ${known_string/:*} == "$left" ] && node=$right || node=$left
    case $op in
      "+") value=$((value - ${known_string/*: }));;
      "-") [ $node == $right ] && value=$((${known_string/*: } - value)) || value=$((value + ${known_string/*: }));;
      "*") value=$((value / ${known_string/*: }));;
      "/") [ $node == $right ] && value=$((${known_string/*: } / value)) || value=$((value * ${known_string/*: }));;
    esac
  done
  echo $value
fi

rm $tmp1 $tmp2
