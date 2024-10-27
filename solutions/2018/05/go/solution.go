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

	bytes := []byte(strings.TrimSpace(string(content)))
	if part == 1 {
		fmt.Println(collapsedLen(bytes))
		return
	}

	least := len(bytes)
	for i := 65; i < 91; i++ {
		filteredBytes := []byte{}
		for _, b := range bytes {
			if b != byte(i) && b != byte(i+32) {
				filteredBytes = append(filteredBytes, b)
			}
		}
		l := collapsedLen(filteredBytes)
		if l < least {
			least = l
		}
	}
	fmt.Println(least)
}

func collapsedLen(bytes []byte) int {
	for {
		nextBytes := []byte{}
		for i := 0; i < len(bytes)-1; i++ {
			if bytes[i]^0b100000 == bytes[i+1] {
				i++
			} else {
				nextBytes = append(nextBytes, bytes[i])
			}
		}
		nextBytes = append(nextBytes, bytes[len(bytes)-1])
		if len(bytes) == len(nextBytes) {
			bytes = nextBytes
			break
		}
		bytes = nextBytes
	}
	return len(bytes)
}
