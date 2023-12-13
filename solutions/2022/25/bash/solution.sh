#!/bin/bash
input=$1
part=$2

snafu2dec() {
  local total=0; mult=1;
  for ((i=${#1}-1; i >= 0; i--)); do
    case ${1:i:1} in
      '2') total=$((total + mult*2));;
      '1') total=$((total + mult*1));;
      '0') total=$((total + mult*0));;
      '-') total=$((total + mult*-1));;
      '=') total=$((total + mult*-2));;
    esac
    ((mult*=5))
  done
  echo $total
}

dec2snafu() {
  local mult=${2:-1};
  while true; do
    max_variance=$((mult/2))
    variance=$(( 2*mult - $1)) 
      if ((${variance/-} <= max_variance )); then value=2; break; fi
    variance=$(( 1*mult - $1)) 
      if ((${variance/-} <= max_variance )); then value=1; break; fi
    variance=$(( 0*mult - $1)) 
      if ((${variance/-} <= max_variance )); then value=0; break; fi
    variance=$(( -1*mult - $1)) 
      if ((${variance/-} <= max_variance )); then value=-1; break; fi
    variance=$(( -2*mult - $1)) 
      if ((${variance/-} <= max_variance )); then value=-2; break; fi
    (( mult*=5 ))
  done
  case $value in
    -2) c="=";;
    -1) c="-";;
    *) c=$value;;
  esac
  ((mult == 1)) && echo $c || echo "$c$(dec2snafu $(($1 - value*mult)) $((mult/5)))"
}

dec2snafu $(while read snafu; do snafu2dec $snafu; done <$input | awk '{s+=$1}END{print s}')
