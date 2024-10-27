import sys

def main(input_file, part):
    ranges = []
    for line in open(input_file, 'r'):
        ranges.append(list(int(n) for n in line.split("-")))

    i, found = 0, 0
    while True:
        if i > 4294967295:
            break
        r = next((r for r in ranges if r[0] <= i <= r[1]), None)
        if r:
            i = r[1] + 1
        else:
            if part == "1":
                print(i)
                return
            else:
                found += 1
                i += 1
    print(found)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
