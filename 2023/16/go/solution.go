package main

import (
  "fmt"
  "os"
  "slices"
)

var (
  SlashDirTransform = [4]int{3,2,1,0}
  BackslashDirTransform = [4]int{1,0,3,2}
  grid []byte
  size int
)

type beam struct {
  row int
  col int
  dir int // Clockwise rotations from East
}

func charAt(b beam) byte {
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

func processBeam(b beam, hitGrid []byte) []beam {
  c := charAt(b)
  for c != byte('\n') {
    hitGrid[b.row * (size + 1) + b.col] = byte('#')
    switch c {
      case byte('\\'):
        b.dir = BackslashDirTransform[b.dir]
      case byte('/'):
        b.dir = SlashDirTransform[b.dir]
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
    c = charAt(b)
  }
  return []beam{}
}

func countEnergized(hitGrid []byte) int {
  count := 0
  for _, s := range hitGrid {
    if s == byte('#') {
      count++
    }
  }
  return count
}

func energizedForInitialBeam(b beam) int {
    hitGrid := make([]byte, len(grid))
    beams := []beam{b}
    seen := make(map[beam]bool)
    for len(beams) > 0 {
      currentBeam := beams[0]
      beams = beams[1:]
      if !seen[currentBeam] {
        seen[currentBeam] = true
        newBeams := processBeam(currentBeam, hitGrid)
        beams = append(beams, newBeams...)
      }
    }
    return countEnergized(hitGrid)
}

func main() {
  args := os.Args[1:]
  inputFile := args[0]
  part := args[1]

  grid, _ = os.ReadFile(inputFile)
  size = slices.Index(grid, byte('\n'))
  count := 0

  if part == "1" {
    count = energizedForInitialBeam(beam{0,0,0})
  } else {
    tmp := 0
    for i := 0; i < size; i++ {
      tmp = energizedForInitialBeam(beam{i,0,0})
      if tmp > count { count = tmp }
      tmp = energizedForInitialBeam(beam{0,i,1})
      if tmp > count { count = tmp }
      tmp = energizedForInitialBeam(beam{i,size-1,2})
      if tmp > count { count = tmp }
      tmp = energizedForInitialBeam(beam{size-1,i,3})
      if tmp > count { count = tmp }
    }
  }

  fmt.Printf("%d\n", count)
}
