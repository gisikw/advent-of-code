import sys

def main(input_file, part):
    trap_patterns = ["^^.",".^^","^..","..^"]
    rows = [open(input_file, 'r').read().rstrip()]
    size = 40 if part == "1" else 400000

    while len(rows) < size:
        ref = "." + rows[-1] + "."
        row = ""
        for i in range(0, len(ref)-2):
            row += "^" if ref[i:i+3] in trap_patterns else "."
        rows.append(row)

    print(sum(row.count(".") for row in rows))

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
