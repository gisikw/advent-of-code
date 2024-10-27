import sys

def main(input_file, part):
    steps = list(line.split() for line in open(input_file, 'r'))
    if part == "1":
        part_one(steps)
    else:
        part_two(steps)

def part_one(steps):
    password = "abcdefgh"
    for step in steps:
        if step[0] == "swap" and step[1] == "position":
            a, b = int(step[2]), int(step[5])
            password = swap(password, a, b)
        elif step[0] == "swap":
            a, b = password.index(step[2]), password.index(step[5])
            password = swap(password, a, b)
        elif step[0] == "rotate" and step[1] == "based":
            password = rotate_based(password, step[6])
        elif step[0] == "rotate":
            amt = int(step[2])
            if step[1] == "right":
                amt *= -1
            password = password[amt:] + password[:amt]
        elif step[0] == "reverse":
            a, b = int(step[2]), int(step[4])
            password = password[:a] + password[a:b+1][::-1] + password[b+1:]
        elif step[0] == "move":
            a, b = int(step[2]), int(step[5])
            c = password[a]
            password = password[:a] + password[a+1:]
            password = password[:b] + c + password[b:]
    print(password)

def part_two(steps):
    password = "fbgdceah"
    for step in steps[::-1]:
        if step[0] == "swap" and step[1] == "position":
            a, b = int(step[2]), int(step[5])
            password = swap(password, a, b)
        elif step[0] == "swap":
            a, b = password.index(step[2]), password.index(step[5])
            password = swap(password, a, b)
        elif step[0] == "rotate" and step[1] == "based":
            orig_password = password[1:] + password[:1]
            while rotate_based(orig_password, step[6]) != password:
                orig_password = orig_password[1:] + orig_password[:1]
            password = orig_password
        elif step[0] == "rotate":
            amt = int(step[2])
            if step[1] == "left":
                amt *= -1
            password = password[amt:] + password[:amt]
        elif step[0] == "reverse":
            a, b = int(step[2]), int(step[4])
            password = password[:a] + password[a:b+1][::-1] + password[b+1:]
        elif step[0] == "move":
            a, b = int(step[2]), int(step[5])
            a, b = b, a
            c = password[a]
            password = password[:a] + password[a+1:]
            password = password[:b] + c + password[b:]
    print(password)

def swap(s, a, b):
    if b < a:
        a, b = b, a
    return s[:a] + s[b] + s[a+1:b] + s[a] + s[b+1:]

def rotate_based(s, c):
    a = s.index(c)
    if a > 3:
        a += 1
    a += 1
    for _ in range(a):
        s = s[-1:] + s[:-1]
    return s

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
