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

	if part == 1 {
		fmt.Println(part1(lines))
	} else {
		fmt.Println(part2(lines))
	}
}

func part1(lines []string) int {
	doubles, triples := 0, 0
	for _, line := range lines {
		freq := make(map[rune]int)
		for _, char := range line {
			freq[char] += 1
		}
		hasDouble, hasTriple := false, false
		for _, val := range freq {
			if val == 2 && !hasDouble {
				hasDouble = true
				doubles++
			}
			if val == 3 && !hasTriple {
				hasTriple = true
				triples++
			}
		}
	}
	return doubles * triples
}

func part2(lines []string) string {
	for i, a := range lines {
		for j := i + 1; j < len(lines); j++ {
			if len(a) != len(lines[j]) || a == lines[j] {
				continue
			}
			diff := -1
			for k := range a {
				if a[k] != lines[j][k] {
					if diff != -1 {
						diff = -1
						break
					}
					diff = k
				}
			}
			if diff != -1 {
				return a[:diff] + a[diff+1:]
			}
		}
	}
	return ""
}
