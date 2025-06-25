package aoc

object Solution {
  def main(args: Array[String]): Unit = {
    val inputFile = args(0)
    val part = args(1)
    val content = scala.io.Source.fromFile(inputFile).getLines().toList

    println(s"Received ${content.length} lines of input for part $part")
  }
}
