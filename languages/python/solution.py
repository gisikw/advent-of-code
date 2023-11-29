import sys

def main(input_file, part):
    with open(input_file, 'r') as file:
        lines = file.readlines()
        lines_count = len(lines)

        print(f"Received {lines_count} lines of input for part {part}")

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
