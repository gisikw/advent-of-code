package main

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

type Claim struct {
	Id     int
	X0     int
	Y0     int
	Width  int
	Height int
}

type Point struct {
	X int
	Y int
}

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	part, _ := strconv.Atoi(args[1])
	lines := strings.Split(strings.TrimSpace(string(content)), "\n")

	fabricMap := make(map[Point]int)
	claims := []Claim{}
	for _, line := range lines {
		claims = append(claims, parse(line))
	}

	for _, claim := range claims {
		for x := claim.X0; x < claim.X0+claim.Width; x++ {
			for y := claim.Y0; y < claim.Y0+claim.Height; y++ {
				fabricMap[Point{x, y}]++
			}
		}
	}

	if part == 1 {
		overlaps := 0
		for _, value := range fabricMap {
			if value > 1 {
				overlaps++
			}
		}
		fmt.Println(overlaps)
		return
	}

	for _, claim := range claims {
		if noOverlaps(claim, fabricMap) {
			fmt.Println(claim.Id)
			return
		}
	}
}

var pattern = regexp.MustCompile(`#(\d+) @ (\d+),(\d+): (\d+)x(\d+)`)

func parse(line string) Claim {
	match := pattern.FindStringSubmatch(line)
	id, _ := strconv.Atoi(match[1])
	x0, _ := strconv.Atoi(match[2])
	y0, _ := strconv.Atoi(match[3])
	width, _ := strconv.Atoi(match[4])
	height, _ := strconv.Atoi(match[5])
	return Claim{Id: id, X0: x0, Y0: y0, Width: width, Height: height}
}

func noOverlaps(claim Claim, claims map[Point]int) bool {
	for x := claim.X0; x < claim.X0+claim.Width; x++ {
		for y := claim.Y0; y < claim.Y0+claim.Height; y++ {
			if claims[Point{x, y}] > 1 {
				return false
			}
		}
	}
	return true
}
