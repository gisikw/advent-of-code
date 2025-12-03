BEGIN {
  size = part == 1 ? 2 : 12
}
{
  split($0, chars, "")
  for (b=1; b <= size; b++) {
    bv[b] = 0
    for (i=bi[b-1]+1; i <= length($0) - (size - b); i++) {
      if (chars[i] > bv[b]) {
        bv[b]=chars[i]
        bi[b] = i
      }
    }
    sum += bv[b] * 10 ^ (size - b)
  }
}
END {
  printf "%d\n", sum
}
