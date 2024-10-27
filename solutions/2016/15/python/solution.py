import sys
import re

def main(input_file, part):
    discs = []

    for i, line in enumerate(open(input_file, 'r')):
        match = re.search(r"(\d+) positions;.*position (\d+)", line)
        size, pos = list(int(n) for n in match.groups()) 
        rel_pos = (pos + 1 + i) % size
        discs.append([size, rel_pos])

    if part == "2":
        discs.append([11, len(discs) + 1])

    i = 0
    while not all(disc[1] == 0 for disc in discs):
        i += 1
        for disc in discs:
            disc[1] = (disc[1] + 1) % disc[0]

    print(i)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
