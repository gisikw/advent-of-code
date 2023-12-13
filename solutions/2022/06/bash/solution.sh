#!/bin/bash
input=$1
part=${2:-1}

[ $part -eq 1 ] && len=4 || len=14; i=0; signal=$(cat $input)
while true; do
  read dup < <(awk -v FS="" '{
    for(i=1;i<=NF;i++) {
      if(a[$i]!=0) break
      a[$i]=i
    }
  }
  END {print a[$i]}' <<< ${signal:$i:$len})
  [ -z "$dup" ] && break
  ((i+=dup))
done
echo $((i+len))
