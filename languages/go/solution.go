package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
)

func main() {
    args := os.Args[1:]
    inputFile := args[0]
    part, _ := strconv.Atoi(args[1])

    file, _ := os.Open(inputFile)
    defer file.Close()

    scanner := bufio.NewScanner(file)
    linesCount := 0
    for scanner.Scan() {
        linesCount++
    }

    fmt.Printf("Received %d lines of input for part %d\n", linesCount, part)
}

