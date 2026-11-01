package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Node struct {
	Children []Node
	Metadata []int
}

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	part, _ := strconv.Atoi(args[1])
	strs := strings.Split(strings.TrimSpace(string(content)), " ")
	tokens := make([]int, len(strs))
	for i, t := range strs {
		tokens[i], _ = strconv.Atoi(t)
	}
	root, _ := parse(tokens)

	if part == 1 {
		fmt.Println(total_msum(root))
	} else {
		fmt.Println(value(root))
	}
}

func parse(tokens []int)(Node, []int) {
	csize, msize := tokens[0], tokens[1]
	tokens = tokens[2:]
	node := Node{}
	for i:=0; i < csize; i++ {
		child, remaining := parse(tokens)
		tokens = remaining
		node.Children = append(node.Children, child)
	}
	node.Metadata = tokens[0:msize]
	tokens = tokens[msize:]
	return node, tokens
}

func msum(node Node)(int) {
	sum := 0
	for i:=0; i < len(node.Metadata); i++ {
		sum += node.Metadata[i]
	}
	return sum
}

func total_msum(node Node)(int) {
	sum := msum(node)
	for i:=0; i < len(node.Children); i++ {
		sum += total_msum(node.Children[i])
	}
	return sum
}

func value(node Node)(int) {
	if len(node.Children) == 0 {
		return msum(node)
	}
	val := 0
	for i:=0; i < len(node.Metadata); i++ {
		m := node.Metadata[i] - 1
		if m >= 0 && m < len(node.Children) {
			val += value(node.Children[m])
		}
	}
	return val
}
