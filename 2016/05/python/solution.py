import sys
import hashlib

def main(input_file, part):
    door_id = ""
    with open(input_file, 'r') as file:
        door_id = file.read().rstrip()
    if part == "1":
        part_one(door_id)
    else:
        part_two(door_id)

def part_one(door_id):
    password = ""
    i = 0
    while len(password) < 8:
        s = door_id + str(i)
        digest = hashlib.md5(s.encode()).hexdigest()
        if digest.startswith("00000"):
            password += digest[5]
        i += 1
    print(password)

def part_two(door_id):
    password = "________"
    i = 0
    while "_" in password:
        s = door_id + str(i)
        digest = hashlib.md5(s.encode()).hexdigest()
        if digest.startswith("00000"):
            idx, char = digest[5:7]
            if idx in "01234567" and password[int(idx)] == "_":
                idx = int(idx)
                password = password[:idx] + char + password[idx+1:]
        i += 1
    print(password)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
