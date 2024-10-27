import sys

def main(input_file, part):
    size = 272 if part == "1" else 35651584

    data = open(input_file, 'r').read().rstrip()
    while len(data) < size:
        data += "0" + "".join("1" if c == "0" else "0" for c in data[::-1])
    data = data[:size]

    while len(data) % 2 == 0:
        checksum = ""
        it = iter(data)
        for x,y in zip(it,it):
            checksum += "1" if x == y else "0"
        data = checksum

    print(data)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
