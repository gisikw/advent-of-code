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
	lines := strings.Split(strings.TrimSpace(string(content)), "\n")
	state := to_bs("...." + lines[0][14:])

	ons := map[int]struct{}{}
	for i:=2; i<len(lines); i++ {
		parts := strings.Split(lines[i], " => ")
		if parts[1] == "#" {
			ons[to_i(to_bs(parts[0]))] = struct{}{}
		}
	}

	turns := 20
	if part == 2 {
		turns = 100
	}

	print(state)
	for i:=0; i<turns; i++ {
		state = tick(state, ons)
		print(state)
	}

	if part == 1 {
		fmt.Println(score(state, turns))
	} else {
		s := score(state, turns)
		delta := score(tick(state, ons), turns + 1) - s
		fmt.Println(delta * (50000000000 - turns) + s)
	}
}

func print(state []bool) {
	for i:=0; i<len(state); i++ {
		if state[i] {
			fmt.Print("#")
		} else {
			fmt.Print(".")
		}
	}
	fmt.Print("\n")
}

func tick(state []bool, ons map[int]struct{}) []bool {
	state = slices.Concat(state, []bool{false,false,false,false})
	next := make([]bool, len(state))
	for i:=0; i<len(state)-4; i++ {
		if _, ok := ons[to_i(state[i:i+5])]; ok {
			next[i+2] = true
		}
	}
	return next
}

func to_bs(s string) []bool {
	result := make([]bool, len(s))
	for i:=0; i<len(s); i++ {
		if s[i] == '#' {
			result[i] = true
		}
	}
	return result
}

func to_i(window []bool) int {
	num := 0
	for i:=0; i < len(window); i++ {
		num <<= 1
		if window[i] {
			num += 0b1
		}
	}
	return num
}

func score(state []bool, turns int) int {
	sum :=0
	for i:=0; i<len(state); i++ {
		if state[i] {
			val := i - 5
			sum += val
		}
	}
	return sum
}
