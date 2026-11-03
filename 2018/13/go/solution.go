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
	dirs := map[byte]complex128{'^': -1i, 'v': 1i, '<': -1, '>': 1}

	for y:=0; y<len(lines); y++ {
		for x:=0; x<len(lines[y]); x++ {
			if d, ok := dirs[lines[y][x]]; ok { 
				carts = append(carts, Cart{Pos: complex(float64(x), float64(y)), Dir: d})
			}
		}
		lines[y] = strings.NewReplacer("<","-",">","-","^","|","v","|").Replace(lines[y])
	}

	done:
	for i:=1; ; i++ {
		// print(lines, grid)

		slices.SortFunc(carts, func(a, b Cart) int {
			return cmp.Or(cmp.Compare(imag(a.Pos), imag(b.Pos)), cmp.Compare(real(a.Pos), real(b.Pos)))
		})

		for c:=0; c < len(carts); c++ {
			cart := &carts[c]

			// Guard
			if cart.Round == i {
				continue
			}
			cart.Round = i

			// Move
			delete(grid, cart.Pos)
			cart.Pos += cart.Dir
			x := real(cart.Pos)
			y := imag(cart.Pos)

			// Crash
			if _, ok := grid[cart.Pos]; ok {
				if part == 1 {
					fmt.Printf("%d,%d\n", int(x), int(y))
					break done
				}
				pos := cart.Pos
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
			grid[cart.Pos] = carts[c]

			// Turn
			switch lines[int(y)][int(x)] {
			case '/':
				cart.Dir = complex(real(cart.Dir), -imag(cart.Dir)) * -1i
			case '\\':
				cart.Dir = complex(real(cart.Dir), -imag(cart.Dir)) * 1i
			case '+':
				if cart.Turn == 0 {
					cart.Dir *= -1i
				} else if cart.Turn == 2 {
					cart.Dir *= 1i
				}
				cart.Turn = (cart.Turn + 1) % 3
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
