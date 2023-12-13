#!/bin/bash
input=$1
part=${2:-1}
bp_id=${3:-0}

pattern_string='
  s/Blueprint \\([0-9]*\\): Each ore robot costs \\([0-9]*\\) ore. 
  Each clay robot costs \\([0-9]*\\) ore. 
  Each obsidian robot costs \\([0-9]*\\) ore and \\([0-9]*\\) clay. 
  Each geode robot costs \\([0-9]*\\) ore and \\([0-9]*\\) obsidian./\\1 \\2 \\3 \\4 \\5 \\6 \\7/p'
read pattern_string < <(tr -s $'\n' ' ' <<< $pattern_string)

get_most_geodes_for_blueprint_string() {
  read blueprint_id ore_ore_cost clay_ore_cost obsidian_ore_cost obsidian_clay_cost geode_ore_cost geode_obsidian_cost < <(sed -n "$pattern_string" <<< $1)
  max_time=$2
  read max_ore_cost < <(tr ' ' $'\n' <<< "$ore_ore_cost $clay_ore_cost $obsidian_ore_cost $geode_ore_cost" | sort -n | tail -1)
  max_producible_geodes=(0)
  for ((t=1; t <= $max_time; t++)); do
    g=$((${max_producible_geodes[t-1]} + (t-1)))
    max_producible_geodes[t]=$((g < 0 ? 0 : g))
  done
  best_seen=0; result=0
  get_most_geodes_for_state $max_time 0 0 0 0 1 0 0 0
}

get_most_geodes_for_state() {
  # t=$1 ore=$2 clay=$3 obsidian=$4 geodes=$5 ore_bots=$6 clay_bots=$7 obsidian_bots=$8 geode_bots=$9
  local score=0 t2=$(($1)) t t1 need1 need2 realized_score
 
  # Return number of geodes if we're done
  (( $1 == 0 )) && result=$5 && return

  realized_score=$(( $5 + ($9 * $1) ))
  (( realized_score + ${max_producible_geodes[$1]} < best_seen )) && result=0 && return
  (( realized_score > best_seen )) && best_seen=$realized_score

  # Recurse into a geode bot purchase if we can produce the components in time
  if (( $8 > 0 )); then
    need1=$(($geode_obsidian_cost-$4))
    t=$((need1 < 0 ? 0 : need1 / $8)); ((need1 % $8 > 0)) && ((t++))
    need2=$(($geode_ore_cost-$2)) 
    t1=$((need2 < 0 ? 0 : need2 / $6)); ((need2 % $6 > 0)) && ((t1++))
    (( t1 > t )) && t=t1
    ((t++))
    if (( t < t2 )); then
      get_most_geodes_for_state $(($1 - $t)) $(($2 + $6 * $t - $geode_ore_cost)) $(($3 + $7 * $t)) $(($4 + $8 * $t - $geode_obsidian_cost)) $(($5 + $9 * $t)) $6 $7 $8 $(($9 + 1))
      (( t == 1 )) && return # Heuristic - if we can buy a geode bot right now, we always should
      (( $score < $result )) && score=$result
    fi
  fi

  # Recurse into an obsidian bot purchase if we can produce the components in time (and don't have too many)
  if (( $7 > 0 )) && (( $8 < $geode_obsidian_cost )); then
    need1=$(($obsidian_clay_cost-$3))
    t=$((need1 < 0 ? 0 : need1 / $7)); ((need1 % $7 > 0)) && ((t++))
    need2=$(($obsidian_ore_cost-$2)) 
    t1=$((need2 < 0 ? 0 : need2 / $6)); ((need2 % $6 > 0)) && ((t1++))
    (( t1 > t )) && t=t1
    ((t++))
    if (( t < t2 )); then
      get_most_geodes_for_state $(($1 - $t)) $(($2 + $6 * $t - $obsidian_ore_cost)) $(($3 + $7 * $t - $obsidian_clay_cost)) $(($4 + $8 * $t)) $(($5 + $9 * $t)) $6 $7 $(($8 + 1)) $9
      (( $score < $result )) && score=$result
    fi
  fi

  # Recurse into a clay bot purchase if we can produce the components in time (and don't have too many)
  if (( $7 < $obsidian_clay_cost )); then
    need1=$(($clay_ore_cost-$2))
    t=$((need1 < 0 ? 0 : need1 / $6)); ((need1 % $6 > 0)) && ((t++))
    ((t++))
    if (( $t < $t2 )); then
      get_most_geodes_for_state $(($1 - $t)) $(($2 + $6 * $t - $clay_ore_cost)) $(($3 + $7 * $t)) $(($4 + $8 * $t)) $(($5 + $9 * $t)) $6 $(($7 + 1)) $8 $9
      (( $score < $result )) && score=$result
    fi
  fi

  # Recurse into an ore bot purchase if we can produce the components in time (and don't have too many)
  if (( $6 < $max_ore_cost )); then
    need1=$(($ore_ore_cost-$2))
    t=$((need1 < 0 ? 0 : need1 / $6)); ((need1 % $6 > 0)) && ((t++))
    ((t++))
    if (( $t < $t2 )); then
      get_most_geodes_for_state $(($1 - $t)) $(($2 + $6 * $t - $ore_ore_cost)) $(($3 + $7 * $t)) $(($4 + $8 * $t)) $(($5 + $9 * $t)) $(($6 + 1)) $7 $8 $9
      (( $score < $result )) && score=$result
    fi
  fi

  # Recurse into the end state, making no purchases
  get_most_geodes_for_state 0 $(($2 + $6 * $1)) $(($3 + $7 * $1)) $(($4 + $8 * $1)) $(($5 + $9 * $1)) $6 $7 $8 $9
  (( $score < $result )) && score=$result
  
  result=$score
}

if [ $part -eq 1 ]; then
  while read line; do
    read bpid < <(cut -d' ' -f2 <<< $line)
    get_most_geodes_for_blueprint_string "$line" 24
    echo $((result * ${bpid/:}))
  done <$input | awk '{s+=$1}END{print s}'
else
  while read line; do
    get_most_geodes_for_blueprint_string "$line" 32
    echo $result
  done < <(cat $input | head -n 3) | awk 'BEGIN{m=1}{m*=$1}END{print m}'
fi
