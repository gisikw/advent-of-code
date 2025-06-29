package main

import (
	"fmt"
	"os"
	"slices"
	"strconv"
	"strings"
)

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	part, _ := strconv.Atoi(args[1])
	lines := strings.Split(strings.TrimSpace(string(content)), "\n")

	slices.Sort(lines)

	schedules := make(map[int]map[int]int)

	currentGuard := 0
	for i, line := range lines {
		parts := strings.Fields(line)
		if parts[2] == "Guard" {
			guard, _ := strconv.Atoi(parts[3][1:])
			currentGuard = guard
		} else if parts[2] == "wakes" {
			_, ok := schedules[currentGuard]
			if !ok {
				schedules[currentGuard] = make(map[int]int)
			}
			sleepStartStr := strings.Split(strings.Fields(lines[i-1])[1], ":")[1]
			sleepStart, _ := strconv.Atoi(sleepStartStr[:len(sleepStartStr)-1])
			sleepEndStr := strings.Split(parts[1], ":")[1]
			sleepEnd, _ := strconv.Atoi(sleepEndStr[:len(sleepEndStr)-1])

			for j := sleepStart; j < sleepEnd; j++ {
				schedules[currentGuard][j]++
			}
		}
	}

	sleepiestGuard := 0
	sleepiestGuardCount := 0
	sleepiestGuardMinute := 0
	sleepiestOverallMinute := 0
	sleepiestOverallMinuteCount := 0
	sleepiestOverallMinuteGuard := 0

	for guard, schedule := range schedules {
		sleepCount := 0
		sleepiestMinuteCount := 0
		sleepiestMinute := -1
		for minute, sleeps := range schedule {
			sleepCount += sleeps
			if sleeps > sleepiestMinuteCount {
				sleepiestMinuteCount = sleeps
				sleepiestMinute = minute
			}
			if sleeps > sleepiestOverallMinuteCount {
				sleepiestOverallMinute = minute
				sleepiestOverallMinuteCount = sleeps
				sleepiestOverallMinuteGuard = guard
			}
		}
		if sleepCount > sleepiestGuardCount {
			sleepiestGuard = guard
			sleepiestGuardCount = sleepCount
			sleepiestGuardMinute = sleepiestMinute
		}
	}

	if part == 1 {
		fmt.Println(sleepiestGuard * sleepiestGuardMinute)
	} else {
		fmt.Println(sleepiestOverallMinute * sleepiestOverallMinuteGuard)
	}
}
