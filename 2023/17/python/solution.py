import sys
import math
from queue import PriorityQueue
from functools import partial

MOVEMENT = [(0,1),(1,0),(0,-1),(-1,0)]
SYMBOLS = [">", "V", "<", "^"]

def main(input_file, part):
    with open(input_file, 'r') as file:
        grid = list(map(list, file.readlines()))
        neighbors_func = partial(neighbors, (0,3) if part == "1" else (4,10))
        score, path = dijkstra(grid, neighbors_func)
        print_path(grid, path)
        print(score)

def print_path(grid, path):
    for (row, col, rot, rep) in path:
        grid[row][col] = SYMBOLS[rot]
    print(''.join(''.join(row) for row in grid))

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
                return alt, trace_path(ncell, prev)
            pq.put((dist[ncell], ncell))

def trace_path(cell, prev):
    path = []
    while cell:
        path.append(cell)
        cell = prev.get(cell, None)
    path.reverse()
    return path

def sides(dir):
    return (dir + 3) % 4, (dir + 1) % 4

def inbounds(row, col, grid):
    return 0 <= row < len(grid) and 0 <= col < len(grid[0]) - 1

def neighbors(config, cell, grid):
    min_straight, max_straight = config
    row, col, rot, rep = cell
    rem_straight = max(min_straight - rep, 1)
    results = []
    for dir in range(0,4):
        if (rot in sides(dir) and rep >= min_straight) or (rot == dir and rep < max_straight):
            drow, dcol = MOVEMENT[dir]
            nrow, ncol = row + drow, col + dcol
            if inbounds(row + (drow * rem_straight), col + (dcol * rem_straight), grid):
                results.append((int(grid[nrow][ncol]), (nrow, ncol, dir, 1 if rot != dir else rep + 1)))
    return results

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
