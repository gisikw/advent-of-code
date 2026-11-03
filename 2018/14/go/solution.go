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
	s := strings.TrimSpace(string(content))
	target, _ := strconv.Atoi(s)
	pattern := []int{}
	for i:=0; i < len(s); i++ {
		digit, _ := strconv.Atoi(s[i:i+1])
		pattern = append(pattern, digit)
	}
	p_len := len(pattern)

	board := []int{3,7}

	j := 0
	k := 1

	idx := 0
	for i:=0; i<target + 10 || part == 2; i++ {
		sum := board[j] + board[k]
		if sum > 9 {
			board = append(board, 1)
		}
		board = append(board, sum % 10)

		b_len := len(board)
		j = (j + board[j] + 1) % b_len
		k = (k + board[k] + 1) % b_len

		if i == target {
			idx = i
		}

		if part == 2 && b_len > p_len {
			if slices.Equal(board[b_len-p_len:], pattern) {
				fmt.Println(b_len - p_len)
				break
			}
			if slices.Equal(board[b_len-p_len-1:b_len-1], pattern) {
				fmt.Println(b_len - p_len - 1)
				break
			}
		}
	}

	if part == 1 {
		res := ""
		for i:=idx; i < idx+10; i++ {
			res += strconv.Itoa(board[i])
		}
		fmt.Println(res)
	}
}
