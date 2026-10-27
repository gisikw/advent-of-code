def main (args : List String) : IO Unit := do
  let f := args[0]!
  let p := args[1]!
  let ls ← IO.FS.lines f
  IO.println s!"Received {ls.size} lines of input for part {p}"
