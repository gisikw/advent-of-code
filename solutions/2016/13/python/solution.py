import sys

def main(input_file, part):
    seed = int(open(input_file, 'r').read())
    queue = [[0,1,1]]
    visited = set()

    while True:
        space = queue.pop(0)
        if not is_open(space, seed):
            continue
        steps, x, y = space
        if steps == 51 and part == "2":
            print(len(visited))
            return
        s = f"{x},{y}"
        if s in visited:
            continue
        visited.add(s)
        if x == 31 and y == 39 and part == "1":
            print(steps)
            return
        queue.append([steps + 1, x + 1, y])
        queue.append([steps + 1, x - 1, y])
        queue.append([steps + 1, x, y + 1])
        queue.append([steps + 1, x, y - 1])

def is_open(space, seed):
    _, x, y = space
    if x < 0 or y < 0:
        return False
    num = x*x + 3*x + 2*x*y + y + y*y + seed
    return bin(num)[2:].count("1") % 2 == 0

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
