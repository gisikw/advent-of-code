import sys
import hashlib
import re

def main(input_file, part):
    salt = open(input_file, 'r').read().rstrip()
    hashes = []
    for i in range(1001):
        hashes.append(hash(salt, i, part))

    keys = 0
    i = 0
    while keys < 64:
        match = re.search(r"(\w)\1{2}",hashes.pop(0))
        if match is not None:
            s = match.groups()[0] * 5
            if any(s in h for h in hashes):
                keys += 1
        i += 1
        hashes.append(hash(salt, i+1000, part))

    print(i - 1)

def hash(salt, i, part):
    h = hashlib.md5(f"{salt}{i}".encode()).hexdigest()
    if part == "1":
        return h
    for _ in range(2016):
        h = hashlib.md5(h.encode()).hexdigest()
    return h

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
