package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"slices"
	"cmp"
)

type Cart struct {
	Pos, Dir complex128
	Turn, Round int
}

func main() {
	args := os.Args[1:]
	inputFile := args[0]

	content, _ := os.ReadFile(inputFile)
	part, _ := strconv.Atoi(args[1])
	lines := strings.Split(string(content), "\n")

	carts := []Cart{}
	grid := make(map[complex128]Cart)

	for y:=0; y<len(lines); y++ {
		for x:=0; x<len(lines[y]); x++ {
			char := lines[y][x]
			if char == 'v' {
				pos := complex(float64(x), float64(y))
				cart := Cart{Pos: pos, Dir: complex(0, 1) }
				carts = append(carts, cart)
				grid[pos] = cart
			} else if char == '^' {
				pos := complex(float64(x), float64(y))
				cart := Cart{Pos: pos, Dir: complex(0, -1) }
				carts = append(carts, cart)
				grid[pos] = cart
			} else if char == '<' {
				pos := complex(float64(x), float64(y))
				cart := Cart{Pos: pos, Dir: complex(-1, 0) }
				carts = append(carts, cart)
				grid[pos] = cart
			} else if char == '>' {
				pos := complex(float64(x), float64(y))
				cart := Cart{Pos: pos, Dir: complex(1, 0) }
				carts = append(carts, cart)
				grid[pos] = cart
			}
		}
		lines[y] = strings.ReplaceAll(strings.ReplaceAll(strings.ReplaceAll(strings.ReplaceAll(lines[y], "<", "-"), ">", "-"), "^", "|"), "v", "|")
	}

	done:
	for i:=1; ; i++ {
		// print(lines, grid)

		slices.SortFunc(carts, func(a, b Cart) int {
			res := cmp.Compare(imag(a.Pos), imag(b.Pos))
			if res == 0 {
				res = cmp.Compare(real(a.Pos), real(b.Pos))
			}
			return res
		})

		for c:=0; c < len(carts); c++ {
			// Guard
			if carts[c].Round == i {
				continue
			}
			carts[c].Round = i

			// Move
			delete(grid, carts[c].Pos)
			carts[c].Pos += carts[c].Dir
			x := real(carts[c].Pos)
			y := imag(carts[c].Pos)

			// Crash
			_, ok := grid[carts[c].Pos]; if ok {
				if part == 1 {
					fmt.Printf("%d,%d\n", int(x), int(y))
					break done
				}
				pos := carts[c].Pos
				delete(grid, pos)
				carts = slices.DeleteFunc(carts, func(d Cart) bool {
					return d.Pos == pos
				})
				if len(carts) == 1 {
					x2 := real(carts[0].Pos)
					y2 := imag(carts[0].Pos)
					fmt.Printf("%d,%d\n", int(x2), int(y2))
					break done
				}
				c = 0
				continue
			}
			grid[carts[c].Pos] = carts[c]

			// Turn
			char := lines[int(y)][int(x)]
			if char == '/' {
				carts[c].Dir = complex(real(carts[c].Dir), -imag(carts[c].Dir)) * -1i
			} else if char == '\\' {
				carts[c].Dir = complex(real(carts[c].Dir), -imag(carts[c].Dir)) * 1i
			} else if char == '+' {
				if carts[c].Turn == 0 {
					carts[c].Dir *= -1i
				} else if carts[c].Turn == 2 {
					carts[c].Dir *= 1i
				}
				carts[c].Turn = (carts[c].Turn + 1) % 3
			}
		}
	}

}

func print(lines []string, grid map[complex128]Cart) {
	for y:=0; y<len(lines); y++ {
		for x:=0; x<len(lines[y]); x++ {
			c, ok := grid[complex(float64(x), float64(y))]; if ok {
				if real(c.Dir) == 1 {
					fmt.Printf(">")
				} else if real(c.Dir) == -1 {
					fmt.Printf("<")
				} else if imag(c.Dir) == -1 {
					fmt.Printf("^")
				} else {
					fmt.Printf("v")
				}
			} else {
				fmt.Printf(lines[y][x:x+1])
			}
		}
		fmt.Printf("\n")
	}
	fmt.Printf("\n")
}
