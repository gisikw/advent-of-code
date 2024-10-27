import sys
import re

def main(input_file, part):
    initial_state = [0,0] # Steps, floor
    objects = []
    cache = {}

    for floor, line in enumerate(open(input_file, 'r')):
        for match in re.findall(r"([\w-]+) (?:generator|microchip)", line):
            initial_state.append(floor)
            objects.append(match)

    if part == "2":
        initial_state += [0,0,0,0]
        objects += [
            "elerium",
            "elerium-compatible",
            "dilithium",
            "dilithium-compatible"
        ]

    queue = [initial_state]

    while True:
        state = queue.pop(0)
        for next_state in children(state, objects):
            if all(n == 3 for n in next_state[1:]):
                print(next_state[0])
                return
            if cache_add(cache, next_state):
                queue.append(next_state)

def children(state, objects):
    floor = state[1]
    indices = []
    for i, f in enumerate(state[2:]):
        if f == floor:
            indices.append(i+2)
    move_set = []
    for i, _ in enumerate(indices):
        move_set.append([indices[i]])
        for j in indices[i+1:]:
            move_set.append([indices[i],j])
    next_floors = []
    if floor < 3:
        next_floors.append(floor+1)
    if floor > 0:
        next_floors.append(floor-1)
    next_states = []
    for floor in next_floors:
        for move in move_set:
            next_state = state.copy()
            next_state[0] += 1
            next_state[1] = floor
            for i in move:
                next_state[i] = floor
            if is_stable(next_state, objects):
                next_states.append(next_state)
    return next_states

def is_stable(state, objects):
    for floor in range(4):
        chips, rtgs = [], []
        for i, f in enumerate(state[2:]):
            if f == floor:
                thing = objects[i]
                (chips if "-" in thing else rtgs).append(thing)
        if len(rtgs):
            for chip in chips:
                if chip.split("-")[0] not in rtgs:
                    return False
    return True

def cache_add(cache, state):
    steps, key = state[0], "".join(str(n) for n in state[1:])
    if key in cache:
        return False
    cache[key] = steps
    return True

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
