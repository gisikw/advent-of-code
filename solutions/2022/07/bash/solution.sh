#!/bin/bash
input=$(realpath $1)
part=${2:-1}

wd="/"
files=""

while read cmd; do
  if [ "${cmd:0:1}" == "$" ]; then
    if [ "${cmd:2:2}" == "cd" ]; then
      path="${cmd:5}"
      case $path in
        /) wd="/";;
        ..) wd="$(echo "$(dirname $wd)/" | sed 's/\/\//\//')";;
        *) wd="$wd$path/";;
      esac
    fi
  else
    read size name <<< $cmd
    if [ "$size" == "dir" ]; then
      size=""
      name="$name/"
    fi
    files+="$wd$name $size"$'\n'
  fi
done < <(cat $input)
files+="/ "
files=$(echo "$files" | sort | uniq)

while read dir; do
  size=$(echo "$files" | grep "$dir.*[^\/] " | cut -d' ' -f2 | awk '{s+=$1} END {print s}')
  files=$(echo "$files" | sed "s~^$dir ~$dir $size~")
done < <(echo "$files" | grep '/ ' | awk -F "/" '{print NF-1, $0}' | sort -nr | cut -d' ' -f2)

if [ $part -eq 1 ]; then
  echo "$files" | grep '/ ' | cut -d' ' -f2 | awk '{if($1<=100000)s+=$1} END {print s}'
else
  target=$((30000000-(70000000-$(echo "$files" | grep '^/ ' | cut -d' ' -f2))))
  echo "$files" | grep '/ ' | cut -d' ' -f2 | awk '{if($1>'"$target"')print $1}' | sort -n | head -n 1
fi
