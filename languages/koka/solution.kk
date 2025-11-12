import std/os/env
import std/os/path
import std/os/file

fun main()
  val [input-file, part] = get-args()
  val input-path = path(input-file)
  val contents = trim-right(read-text-file(input-path))
  val lines = split(contents, "\n")
  println("Received " ++ show(length(lines)) ++ " lines of input for part " ++ part)
