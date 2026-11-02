package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"slices"
)

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	part, _ := strconv.Atoi(args[1])
	words := strings.Split(strings.TrimSpace(string(content)), " ")
	players, _ := strconv.Atoi(words[0])
	max_points, _ := strconv.Atoi(words[6])

	if part == 2 {
		max_points *= 100
	}

	current := 0
	board := []int{0}
	scores := make([]int, players)
	
	for points:=1; points<=max_points; points++ {
		b_len := len(board)
		if points % 23 == 0 {
			current = (current + b_len - 7) % b_len
			scores[points % players] += board[current]
			board = slices.Delete(board, current, current + 1)
		} else {
			current = (current + 2) % b_len
			board = slices.Insert(board, current, points)
		}
	}

	for i:=23; i <= max_points; i+=23 {
		scores[i % players] += i
	}

	fmt.Println(slices.Max(scores))
}
