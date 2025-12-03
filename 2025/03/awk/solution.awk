BEGIN {
  sum = 0
  size = part == 1 ? 2 : 12
  bati[0] = 0
}
{
  split($0, chars, "")
  for (b=1; b <= size; b++) {
    batv[b] = 0
    for (i=bati[b-1]+1; i <= length($0) - (size - b); i++) {
      if (chars[i] > batv[b]) {
        batv[b]=chars[i]
        bati[b] = i
      }
    }
    sum += batv[b] * 10 ^ (size - b)
  }
}
END {
  printf "%d\n", sum
}
