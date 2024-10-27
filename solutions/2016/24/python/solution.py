import sys

def main(input_file, part):
    map = open(input_file, 'r').readlines()
    targets = {}
    for row, line in enumerate(map):
        for col, c in enumerate(line):
            if c.isnumeric():
                targets[c] = [row,col]

    seen = set()

    initial_state = targets["0"].copy()
    initial_state.append(0)
    initial_state.append(["0"])

    queue = [initial_state]
    while True:
        row, col, steps, found = queue.pop(0)
        found = found.copy()
        hash = f"{row},{col},{found}"
        current = map[row][col]
        if current == "#" or hash in seen:
            continue
        if current.isnumeric() and current not in found:
            found.append(current)
        if len(found) == len(targets):
            if part == "1" or current == "0":
                print(steps)
                return
        seen.add(hash)
        queue.append([row + 1, col, steps + 1, found])
        queue.append([row - 1, col, steps + 1, found])
        queue.append([row, col + 1, steps + 1, found])
        queue.append([row, col - 1, steps + 1, found])

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
