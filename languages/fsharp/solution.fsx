open System
open System.IO

let args = fsi.CommandLineArgs

let inputFile = args.[1]
let part = args.[2]

let lines = File.ReadAllLines inputFile
let linesCount = lines.Length

printfn "Received %d lines of input for part %s" linesCount part
