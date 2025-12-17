package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"math"
)

type Coord struct {
	X, Y  int
	Count int
}

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, err := os.ReadFile(inputFile)
	if err != nil { panic(err) }
	part, err := strconv.Atoi(args[1])
	if err != nil { panic(err) }

	minX := math.MaxInt
	minY := math.MaxInt
	maxX := 0
	maxY := 0

	lines := strings.Split(strings.TrimSpace(string(content)), "\n")
	coords := make([]Coord, len(lines));
	for i, line := range lines {
		parts := strings.Split(line, ", ")

		x, err := strconv.Atoi(parts[0])
		if err != nil { panic(err) }
		coords[i].X = x
		minX = min(minX, x)
		maxX = max(maxX, x)

		y, err := strconv.Atoi(parts[1])
		if err != nil { panic(err) }
		coords[i].Y = y
		minY = min(minY, y)
		maxY = max(maxY, y)
	}


	if part == 1 {
		maxCoord := 0
		for x := minX; x <= maxX; x++ {
			for y := minY; y <= maxY; y++ {
				minDistance := math.MaxInt
				nearest := -1
				for i, c := range coords {
					if c.X == x && c.Y == y {
						continue
					}

					distance := AbsInt(c.X - x) + AbsInt(c.Y - y)
					if distance < minDistance {
						nearest = i
						minDistance = distance
					} else if distance == minDistance {
						nearest = -1
					}
				}
				if nearest != -1 {
					// Skip border checks because we can get away with it this early
					coords[nearest].Count++
					if coords[nearest].Count > maxCoord {
						maxCoord = coords[nearest].Count
					}
				}
			}
		}
		fmt.Printf("%d\n", maxCoord);
	} else {
		region := 0
		for x := maxX - 10000; x <= minX + 10000; x++ {
			for y := maxY - 10000; y <= minY + 10000; y++ {
				distance := 0
				for _, c := range coords {
					distance += AbsInt(c.X - x) + AbsInt(c.Y - y)
				}
				if distance < 10000 {
					region++
				}
			}
		}
		fmt.Printf("%d\n", region);
	}
}

func AbsInt(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
