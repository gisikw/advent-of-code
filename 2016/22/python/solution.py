import sys
import re

def main(input_file, part):
    nodes = []
    for line in open(input_file, 'r').readlines()[2:]:
        name, size, used, avail = line.split()[:4]
        nodes.append([
            name, 
            int(size.rstrip("T")), 
            int(used.rstrip("T")), 
            int(avail.rstrip("T"))
        ])

    if part == "1":
        part_one(nodes)
    else:
        part_two(nodes)

def part_one(nodes):
    pairs = 0
    for n in nodes:
        used = n[2]
        if used > 0:
            for m in nodes:
                if n != m and used <= m[3]:
                    pairs += 1
    print(pairs)

def part_two(nodes):
    size_threshold = min(node[1] for node in nodes)
    blocked = set()
    max_x = max(int(re.findall(r"\d+", node[0])[0]) for node in nodes)
    max_y = max(int(re.findall(r"\d+", node[0])[1]) for node in nodes)
    for node in nodes:
        if node[2] == 0:
            space = list(int(n) for n in re.findall(r"\d+", node[0]))
        if node[2] > size_threshold:
            blocked.add(",".join(re.findall(r"\d+", node[0])))
    # print(blocked)
    # print(space)

    # While pathfinding is feasible here (first to move the space to adjacent
    # to the target, then to move the target), this is much easier by just
    # counting swaps on the map.
    steps = 0
    steps += space[0] # Move space to x = 0
    steps += space[1] # Move space to y = 0
    steps += max_x # Move space to the the right of the target node, with target swapped to the left
    steps += (max_x - 1) * 5 # Five steps for each new move of the target node
    print(steps)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
