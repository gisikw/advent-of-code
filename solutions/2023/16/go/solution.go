package main

import (
  "fmt"
  "os"
  "slices"
)

type beam struct {
  row int
  col int
  dir int // Clockwise rotations from East
}

func charAt(b beam, grid []byte, size int) byte {
  idx := b.row * (size + 1) + b.col
  if idx < 0 || idx >= len(grid) {
    return byte('\n')
  }
  return grid[idx]
}

func move(b *beam) {
  switch b.dir {
    case 0:
      b.col++
    case 1:
      b.row++
    case 2:
      b.col--
    case 3:
      b.row--
  }
}

func backslashDir(dir int) int {
  switch dir {
    case 0:
      return 1
    case 1:
      return 0
    case 2:
      return 3
    case 3:
      return 2
  }
  return 0
}

func slashDir(dir int) int {
  switch dir {
    case 0:
      return 3
    case 1:
      return 2
    case 2:
      return 1
    case 3:
      return 0
  }
  return 0
}

// Move the beam until we hit something, then generate new beams
func processBeam(b beam, grid []byte, hitGrid []byte, size int) []beam {
  c := charAt(b, grid, size)
  for c != byte('\n') {
    hitGrid[b.row * (size + 1) + b.col] = byte('#')
    switch c {
      case byte('\\'):
        b.dir = backslashDir(b.dir)
      case byte('/'):
        b.dir = slashDir(b.dir)
      case byte('-'):
        if b.dir == 1 || b.dir == 3 {
          return []beam{beam{b.row,b.col-1,2},beam{b.row,b.col+1,0}}
        }
      case byte('|'):
        if b.dir == 0 || b.dir == 2 {
          return []beam{beam{b.row-1,b.col,3},beam{b.row+1,b.col,1}}
        }
    }
    move(&b)
    c = charAt(b, grid, size)
  }
  return []beam{}
}

func energizedForInitialBeam(b beam, grid []byte, size int) int {
  hitGrid := make([]byte, len(grid))
  // copy(hitGrid, grid) // Unnecessary
  beams := []beam{b}
  seen := []beam{}

  for len(beams) > 0 {
    if slices.Contains(seen, beams[0]) {
      beams = beams[1:]
    } else {
      seen = append(seen, beams[0])
      beams = append(beams[1:], processBeam(beams[0], grid, hitGrid, size)...)
    }
  }

  count := 0
  for _, s := range hitGrid {
    if s == byte('#') {
      count++
    }
  }

  return count
}

func main() {
  args := os.Args[1:]
  inputFile := args[0]
  part := args[1]

  grid, _ := os.ReadFile(inputFile)
  size := slices.Index(grid, byte('\n'))
  count := 0

  if part == "1" {
    count = energizedForInitialBeam(beam{0,0,0},grid,size)
  } else {
    tmp := 0
    for i := 0; i < size; i++ {
      tmp = energizedForInitialBeam(beam{i,0,0},grid,size)
      if tmp > count { count = tmp }
      tmp = energizedForInitialBeam(beam{0,i,1},grid,size)
      if tmp > count { count = tmp }
      tmp = energizedForInitialBeam(beam{i,size-1,2},grid,size)
      if tmp > count { count = tmp }
      tmp = energizedForInitialBeam(beam{size-1,i,3},grid,size)
      if tmp > count { count = tmp }
    }
  }

  fmt.Printf("%d\n", count)
}
