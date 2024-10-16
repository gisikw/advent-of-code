import sys

dirs = [1, 1j, -1, -1j]
def main(input_file, part):
    with open(input_file, 'r') as file:
        pos, dir = 0, 0
        seen = set()
        for step in file.read().rstrip().split(", "):
            dir = (dir + (3 if step[0] == "L" else 1)) % 4
            for _ in range(int(step[1:])):
                pos += dirs[dir]
                if (pos in seen) and part == "2":
                    print(int(abs(pos.real) + abs(pos.imag)))
                    return
                seen.add(pos)
        print(int(abs(pos.real) + abs(pos.imag)))

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
