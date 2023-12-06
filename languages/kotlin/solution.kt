import java.io.File

fun main(args: Array<String>) {
    val inputFile = args[0]
    val part = args[1]

    val lines = File(inputFile).readLines()
    val linesCount = lines.size

    println("Received $linesCount lines of input for part $part")
}
