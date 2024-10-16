import sys

def main(input_file, part):
    if part == "1":
        part_one(input_file)
    else:
        part_two(input_file)

def part_one(input_file):
    count = 0
    with open(input_file, 'r') as file:
        for line in file:
            a, b, c = map(int, line.split())
            if a + b > c and a + c > b and b + c > a:
                count += 1
        print(count)

def part_two(input_file):
    count = 0
    with open(input_file, 'r') as file:
        lines = file.readlines()
        for n in range(0,len(lines),3):
            a, b, c = map(int, lines[n].split())
            d, e, f = map(int, lines[n+1].split())
            g, h, i = map(int, lines[n+2].split())
            if a + d > g and a + g > d and d + g > a:
                count += 1
            if b + e > h and b + h > e and e + h > b:
                count += 1
            if c + f > i and c + i > f and f + i > c:
                count += 1
        print(count)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
