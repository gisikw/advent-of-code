val args = CommandLine.arguments ()
val f = List.nth (args, length args - 2)
val p = List.nth (args, length args - 1)
val ins = TextIO.openIn f
fun count n = case TextIO.inputLine ins of NONE => n | SOME _ => count (n + 1)
val _ = print ("Received " ^ Int.toString (count 0) ^ " lines of input for part " ^ p ^ "\n")
