import sys

def main(input_file, part):
    size = int(open(input_file, 'r').read())

    factor = 1
    if part == "1":
        check = size
        while check % 2 == 0:
            factor *= 2
            check /= 2

    elves = []
    for i in range(1, size+1, factor):
        elves.append(i) 

    if part == "1":
        for _ in range(len(elves) - 1):
            elves.append(elves.pop(0))
            elves.pop(0)
    else:
        for _ in range(len(elves) - 1):
            elves.pop(len(elves) // 2)
            elves.append(elves.pop(0))

    print(elves[0])

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
