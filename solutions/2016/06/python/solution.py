import sys

def main(input_file, part):
    dicts = [{},{},{},{},{},{},{},{}]
    with open(input_file, 'r') as file:
        for line in file.readlines():
            for i, char in enumerate(line.rstrip()):
                if char not in dicts[i]:
                    dicts[i][char] = 0
                dicts[i][char] += 1
    result = ""
    for d in dicts:
        result += sorted(
            d.items(), 
            key=lambda kv: kv[1] * (-1 if part == "1" else 1)
        )[0][0]
    print(result)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
