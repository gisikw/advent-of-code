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

	seen := make(map[int]bool)
	i := 0
	sum := 0
	for {
		num, _ := strconv.Atoi(lines[i])
		sum += num
		if part == 2 && seen[sum] {
			fmt.Println(sum)
			break
		}
		seen[sum] = true
		i = (i + 1) % len(lines)
		if part == 1 && i == 0 {
			fmt.Println(sum)
			break
		}
	}
}
