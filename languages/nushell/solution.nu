def main [f: string, p: string] {
  let n = (open --raw $f | lines | length)
  print $"Received ($n) lines of input for part ($p)"
}
