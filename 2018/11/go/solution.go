package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

var power = [][]int{}

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	part, _ := strconv.Atoi(args[1])
	serial, _ := strconv.Atoi(strings.TrimSpace(string(content)))
	power = make([][]int, 300)

	for x:=0; x < 300; x++ {
		power[x] = make([]int, 300)
		for y:=0; y < 300; y++ {
			power[x][y] = power_level(serial, x + 1, y + 1)
		}
	}

	max := 0
	maxX := 0
	maxY := 0
	maxSize := 3
	for x:=0; x < 298; x++ {
		for y:=0; y < 298; y++ {
			ms := min(298 - x, 298 - y)
			if part == 1 {
				ms = 4
			}
			for s := 3; s < ms; s++ {
				sq := power_square(x, y, s)
				if sq > max {
					max = sq
					maxX = x + 1
					maxY = y + 1
					maxSize = s
				}
			}
		}
	}

	if part == 1 {
		fmt.Printf("%d,%d\n",maxX,maxY)
	} else {
		fmt.Printf("%d,%d,%d\n",maxX,maxY,maxSize)
	}
}

func power_level(serial int, x int, y int) int {
	rack_id := x + 10
	power := rack_id * y
	power += serial
	power *= rack_id
	power /= 100
	power %= 10
	power -= 5
	return power
}

func power_square(x int, y int, size int) int {
	sum := 0
	for sx := 0; sx < size; sx++ {
		for sy := 0; sy < size; sy++ {
			sum += power[x + sx][y + sy]
		}
	}
	return sum
}
