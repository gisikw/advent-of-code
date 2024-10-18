import sys

def main(input_file, part):
    lines = open(input_file, 'r').readlines()
    lines_count = len(lines)

    print(f"Received {lines_count} lines of input for part {part}")

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
