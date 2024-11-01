import "os" for Process
import "io" for File

var args = Process.allArguments
var lines = File.read(args[2]).split("\n")

System.print("Received " + (lines.count - 1).toString + " lines of input for part " + args[3])
