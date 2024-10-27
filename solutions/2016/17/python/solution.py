import sys
import hashlib

def main(input_file, part):
    salt = open(input_file, 'r').read().rstrip()
    queue = [[0,0,""]]
    open_vals = "bcdef"
    max_len = 0
    while len(queue) > 0:
        x, y, path = queue.pop(0)
        if x == 3 and y == 3:
            if part == "1":
                print(path)
                return
            max_len = max(max_len, len(path))
            continue
        hash = hashlib.md5(f"{salt}{path}".encode()).hexdigest()
        if hash[0] in open_vals and y > 0:
            queue.append([x, y - 1, path + "U"])
        if hash[1] in open_vals and y < 3:
            queue.append([x, y + 1, path + "D"])
        if hash[2] in open_vals and x > 0:
            queue.append([x - 1, y, path + "L"])
        if hash[3] in open_vals and x < 3:
            queue.append([x + 1, y, path + "R"])

    print(max_len)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
