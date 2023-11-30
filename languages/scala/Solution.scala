package aoc

object Solution extends App {
  val inputFile = args(0)
  val part = args(1)
  val lines = scala.io.Source.fromFile(inputFile).getLines().toList
  val linesCount = lines.length

  println(s"Received $linesCount lines of input for part $part")
}
