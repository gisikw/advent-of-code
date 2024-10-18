import sys
import re

def main(input_file, part):
    if part == "1":
        part_one(input_file)
    else:
        part_two(input_file)

def part_one(input_file):
    count = 0
    lines = open(input_file, 'r').readlines()
    for line in lines:
        bad = False
        for seq in hypernets(line):
            if has_abba(seq):
                bad = True
                break
        if has_abba(line) and not bad:
            count += 1
    print(count)

def part_two(input_file):
    count = 0
    lines = open(input_file, 'r').readlines()
    for line in lines:
        for _,a,b in abas(re.sub(r"\[[^\]]*\]","",line)):
            matched = False
            for seq in hypernets(line):
                if has_bab(a,b,seq):
                    matched = True
                    break
            if matched:
                count += 1
                break
    print(count)

def has_abba(s):
    return re.search(r"(\w)(?!\1)(\w)\2\1",s) is not None

def hypernets(s):
    return re.findall(r"\[([^\]]*)\]",s)

def abas(s):
    return re.findall(r"(?=((\w)(?!\2)(\w)\2))",s)

def has_bab(a,b,s):
    return re.search(f"{b}{a}{b}",s) is not None

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
