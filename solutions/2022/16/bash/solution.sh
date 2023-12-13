#!/bin/bash
input=$1
part=${2:-1}

valves=(); exits=(); pressures=(); distances=();

while read line; do
  name=${line:6:2}
  valves+=($name)
  i=$((${#valves[@]}-1))
  tunnels=$(echo $line | cut -d';' -f2 | sed 's/,//g')
  exits[$i]="${tunnels:23}"
  pressures[$i]=$(echo "${line/*=/}" | cut -d';' -f1)
done <$input
valve_count=${#valves[@]}; valves_with_pressure=$(echo ${pressures[@]} | tr ' ' $'\n' | grep -v '^0$' | wc -w | tr -d ' ')
AA=$(echo ${valves[@]/AA//} | cut -d/ -f1 | wc -w | tr -d ' ')

# Convert exits to ints, and build distance graph
for ((i=0; i < $valve_count; i++)); do
  exit_str=""
  for e in ${exits[i]}; do
    j=$(cut -d/ -f1 <<< ${valves[@]/$e//} | wc -w | tr -d ' ')
    distances[$((i*100+j))]=1; 
    exit_str="$exit_str $j"
  done
  exits[i]=$exit_str
done

# Compute min distances between all valves
for ((i=0; i < ${#valves[@]}; i++)); do
  [ ${pressures[i]} -ne 0 ] && useful_nodes+=($i)
  unvisited="$(seq -s ' ' 0 $((${#valves[@]}-1)) )"
  unvisited="${unvisited/$i}"
  current_node=$i; current_distance=0;
  while [ ! -z "${unvisited// }" ]; do

    # Compute distances for all immediate neighbors
    for e in ${exits[$current_node]}; do
      [[ ",${unvisited// /,}," != *",$e,"* ]] && continue
      new_distance=$(($current_distance + ${distances[$((current_node*100+e))]}))
      old_distance=${distances[$((i*100+e))]}
      [ -z $old_distance ] && old_distance=99
      [ $new_distance -lt $old_distance ] && distances[$((i*100+e))]=$new_distance
    done

    # Set current_node to the unvisited element of the shortest distance
    next_distance=99; arr=($unvisited)
    for node in ${arr[@]}; do
      d=${distances[$((i*100+node))]}
      [ ! -z $d ] && [ $d -lt $next_distance ] && next_node=$node && next_distance=$d
    done
    current_node=$next_node; current_distance=$next_distance
    unvisited=${unvisited/$current_node}
  done
done
useful_nodes=${useful_nodes[@]}

input_stack=(); output_stack=(); pointer=0;

if [ $part -eq 1 ]; then
  best_score() {
    local t node nodes_remaining score remaining_time s score e
    read t node nodes_remaining <<<${input_stack[pointer]}
    score=0
    for e in $nodes_remaining; do
      remaining_time=$((t - (${distances[$((node*100+e))]}+1)))
      [ $remaining_time -le 0 ] && continue
      input_stack[++pointer]="$remaining_time $e ${nodes_remaining/$e}"
      best_score
      s=$((${output_stack[pointer--]}+$remaining_time*${pressures[e]}))
      [ $s -gt $score ] && score=$s
    done
    output_stack[pointer]=$score
  }
  input_stack[pointer]="30 $AA $useful_nodes"
  best_score
  echo ${output_stack[pointer]}
else
  best_score() {
    local t1 t2 node1 node2 nodes_remaining score remaining_time s score e
    read t1 t2 node1 node2 nodes_remaining <<<${input_stack[pointer]}
    score=0
    if (( t1 < t2 )); then
      for e in $nodes_remaining; do
        remaining_time=$((t2 - (${distances[$((node2*100+e))]}+1)))
        (( remaining_time <= 0 )) && continue
        input_stack[++pointer]="$t1 $remaining_time $node1 $e ${nodes_remaining/$e}"
        best_score
        s=$((${output_stack[pointer--]}+$remaining_time*${pressures[e]}))
        (( s > score )) && score=$s
      done
    else
      for e in $nodes_remaining; do
        remaining_time=$((t1 - (${distances[$((node1*100+e))]}+1)))
        (( remaining_time <= 0 )) && continue
        input_stack[++pointer]="$remaining_time $t2 $e $node2 ${nodes_remaining/$e}"
        best_score
        s=$((${output_stack[pointer--]}+$remaining_time*${pressures[e]}))
        (( s > score )) && score=$s
      done
    fi
    output_stack[pointer]=$score
  }
  input_stack[pointer]="26 26 $AA $AA $useful_nodes"
  best_score
  echo ${output_stack[pointer]}
fi
