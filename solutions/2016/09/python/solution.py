import sys

def main(input_file, part):
    s = open(input_file, 'r').read().rstrip()
    print(parse_str(s, part == "2"))

def parse_str(s, recursive=False):
    count = 0
    i = 0
    while i < len(s):
        if s[i] == "(":
            chars, repeat, i = parse_marker(s, i)
            if recursive:
                count += parse_str(s[i:i+chars],recursive) * repeat
            else:
                count += chars * repeat
            i += chars
        else:
            count += 1
            i += 1
    return count

def parse_marker(s, i):
    chars = ""
    repeat = ""
    i += 1
    while s[i] != "x":
        chars += s[i]
        i += 1
    i += 1
    while s[i] != ")":
        repeat += s[i]
        i += 1
    return int(chars), int(repeat), i + 1

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
