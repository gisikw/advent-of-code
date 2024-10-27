package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	part, _ := strconv.Atoi(args[1])
	lines := strings.Split(strings.TrimSpace(string(content)), "\n")

	fmt.Printf("Received %d lines of input for part %d\n", len(lines), part)
}
