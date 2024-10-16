import sys
import re

def main(input_file, part):
    sum = 0
    real = []
    with open(input_file, 'r') as file:
        for line in file:
            name, id, csum = re.search("([^\\d]+)(\\d+)\\[([^\\]]+)",line.rstrip()).groups()
            if csum == checksum(name.replace("-","")):
                real.append([name, int(id)])
                sum += int(id)
    if part == "1":
        print(sum)
        return
    for s, id in real:
        for _ in range(id):
            s = "".join(map(shift, s))
        if s == "northpole object storage ":
            print(id)
            return

def checksum(s):
    hash = {}
    for c in s:
        if c not in hash:
            hash[c] = 0
        hash[c] += 1
    return "".join(
        map(lambda kv: kv[0], sorted(
            hash.items(), key=lambda kv: (-kv[1], kv[0]))[0:5]))

def shift(char):
    if char == " " or char == "-":
        return " "
    else:
        c = ord(char) + 1
        if c == 123:
            c = 97 
        return chr(c)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
