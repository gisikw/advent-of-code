import sys
import math
from queue import PriorityQueue

def main(input_file, part):
    with open(input_file, 'r') as file:
        grid = list(map(list, file.readlines()))
        score, path = dijkstra(grid, part1_neighbors if part == "1" else part2_neighbors)
        print_path(grid, path)
        print(score)

def print_path(grid, path):
    for (row, col, rot, rep) in path:
        if rot == 0: grid[row][col] = ">"
        if rot == 1: grid[row][col] = "V"
        if rot == 2: grid[row][col] = "<"
        if rot == 3: grid[row][col] = "^"
    flat = [x for xs in grid for x in xs]
    print("".join(flat))

# Each node is a tuple of (row, col, rotation from East, repeats)
# There is some neighbor pruning we ought to be able to do, e.g. Up->Right == Down->Right
def dijkstra(grid, neighbors):
    height = len(grid)
    width = len(grid[0]) - 1
    dist = { (0,0,0,1): 0 }
    prev = {}
    visited = set()
    pq = PriorityQueue()
    pq.put((0, (0,0,0,1)))
    while not pq.empty():
        score, cell = pq.get()
        if cell in visited: continue
        visited.add(cell)
        for weight, ncell in neighbors(cell, grid):
            (nrow, ncol, ndir, nrep) = ncell
            alt = score + weight
            if alt < dist.get(ncell, math.inf):
                dist[ncell] = alt 
                prev[ncell] = cell
            if nrow == height - 1 and ncol == width - 1:
                s = list()
                u = ncell
                while u:
                    s.append(u)
                    u = prev.get(u, None)
                s.reverse()
                return alt, s
            pq.put((dist[ncell], ncell))

def part1_neighbors(cell, grid):
    row, col, rot, rep = cell
    results = list()
    # East
    if rot == 1 or rot == 3 or (rot == 0 and rep < 2):
        if col + 1 < len(grid):
            results.append((int(grid[row][col+1]), (row, col+1, 0, 0 if rot != 0 else rep + 1)))
    # South
    if rot == 0 or rot == 2 or (rot == 1 and rep < 2):
        if row + 1 < len(grid):
            results.append((int(grid[row+1][col]), (row+1, col, 1, 0 if rot != 1 else rep + 1)))
    # West
    if rot == 1 or rot == 3 or (rot == 2 and rep < 2):
        if col - 1 >= 0:
            results.append((int(grid[row][col-1]), (row, col-1, 2, 0 if rot != 2 else rep + 1)))
    # North
    if rot == 0 or rot == 2 or (rot == 3 and rep < 2):
        if row - 1 >= 0:
            results.append((int(grid[row-1][col]), (row-1, col, 3, 0 if rot != 3 else rep + 1)))
    return results

def part2_neighbors(cell, grid):
    row, col, rot, rep = cell
    results = list()
    offset = max(4 - rep, 1)
    # East
    if ((rot == 1 or rot == 3) and rep > 3) or (rot == 0 and rep < 10):
        if col + offset < len(grid[0]) - 1:
            results.append((int(grid[row][col+1]), (row, col+1, 0, 1 if rot != 0 else rep + 1)))
    # South
    if ((rot == 0 or rot == 2) and rep > 3) or (rot == 1 and rep < 10):
        if row + offset < len(grid):
            results.append((int(grid[row+1][col]), (row+1, col, 1, 1 if rot != 1 else rep + 1)))
    # West
    if ((rot == 1 or rot == 3) and rep > 3) or (rot == 2 and rep < 10):
        if col - offset >= 0:
            results.append((int(grid[row][col-1]), (row, col-1, 2, 1 if rot != 2 else rep + 1)))
    # North
    if ((rot == 0 or rot == 2) and rep > 3) or (rot == 3 and rep < 10):
        if row - offset >= 0:
            results.append((int(grid[row-1][col]), (row-1, col, 3, 1 if rot != 3 else rep + 1)))
    return results

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
