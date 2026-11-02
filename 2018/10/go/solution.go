package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	// "time"
)

type Point struct {
	X, Y, VX, VY  int
}

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	lines := strings.Split(strings.TrimSpace(string(content)), "\n")
	points := make([]Point, len(lines))
	for _, line := range lines {
		parts := strings.Split(line[10:42], "> velocity=<")
		pos := strings.Split(parts[0], ",")
		vel := strings.Split(parts[1], ",")
		x, _ := strconv.Atoi(strings.TrimSpace(pos[0]))
		y, _ := strconv.Atoi(strings.TrimSpace(pos[1]))
		vx, _ := strconv.Atoi(strings.TrimSpace(vel[0]))
		vy, _ := strconv.Atoi(strings.TrimSpace(vel[1]))
		points = append(points, Point{X: x, Y: y, VX: vx, VY: vy})
	}

	for i:=0; i < 10036; i++ {
		for p := 0; p < len(points); p++ {
			points[p].X += points[p].VX
			points[p].Y += points[p].VY
		}
	}

	// for i:=0; i < 30; i++ {
	// 	for p := 0; p < len(points); p++ {
	// 		points[p].X += points[p].VX
	// 		points[p].Y += points[p].VY
	// 	}
	// 	print(points)
	// 	time.Sleep(time.Second)
	// }

	print(points)
}

func dims(points []Point)(int, int, int, int) {
	maxX := -99999999
	minX := 99999999
	maxY := -99999999
	minY := 99999999
	for _, p := range points {
		if p.X > maxX {
			maxX = p.X
		}
		if p.X < minX {
			minX = p.X
		}
		if p.Y > maxY {
			maxY = p.Y
		}
		if p.Y < minY {
			minY = p.Y
		}
	}
	return maxX, minX, maxY, minY
}

func print(points []Point) {
	maxX, minX, maxY, minY := dims(points)
	width := (maxX - minX) + 1
	height := (maxY - minY) + 1

	grid := make([][]byte, height)
	for y:=0; y < height; y++ {
		grid[y] = make([]byte, width)
		for x:=0; x < width; x++ {
			grid[y][x] = '.'
		}
	}

	for p := 0; p < len(points); p++ {
		row := points[p].Y - minY
		col := points[p].X - minX
		grid[row][col] = '#'
	}

	for _, line := range grid {
		fmt.Println(string(line))
	}
}
