package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Worker struct {
	Node string
	Tick int
}

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	part, _ := strconv.Atoi(args[1])
	lines := strings.Split(strings.TrimSpace(string(content)), "\n")

	deps := make(map[string][]string)
	remaining := make(map[string]int)
	candidates := make(map[string][]string)

	for _, line := range lines {
		prereq, task := line[5:6], line[36:37]
		deps[task] = append(deps[task], prereq)
		candidates[prereq] = append(candidates[prereq], task)
		remaining[prereq] = 2
	}

	queue := make([]string, 0)
	path := make([]string, 0)

	for node, _ := range remaining {
		if len(deps[node]) == 0 {
			queue = append(queue, node)
		}
	}


	time := 0
	workerCount := 1
	if part == 2 {
		workerCount = 5
	}
	workers := make([]Worker, workerCount)
	done := len(remaining)
	for done >= 0 {
		time++
		for w := range workers {
			if workers[w].Tick > 1 {
				workers[w].Tick--
			} else {
				if workers[w].Tick == 1 {
					done--
					workers[w].Tick = 0
					remaining[workers[w].Node] = 0
					path = append(path, workers[w].Node)
					cand:
					for _, node := range candidates[workers[w].Node] {
						for _, prereq := range deps[node] {
							if remaining[prereq] > 0 {
								continue cand
							}
						}
						queue = append(queue, node)
					}
				}

				if len(queue) > 0 {
					next := "["
					index := 0
					for i, node := range queue {
						if node < next {
							next = node
							index = i
						}
					}
					queue = append(queue[:index], queue[index+1:]...)
					workers[w].Node = next
					remaining[next] = 1
					workers[w].Tick = int(next[0]) - 64 + 60
				}
			}
		}
	}

	if part == 1 {
		fmt.Println(strings.Join(path, ""))
	} else {
		fmt.Println(time - 1)
	}
}
