Red []

args: split system/script/args " "
input-file: args/1
part: args/2

lines: read/lines to-file input-file
lines-count: length? lines

print ["Received" lines-count "lines of input for part" part]
