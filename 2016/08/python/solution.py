import sys
import re

def main(input_file, part):
    arr = []
    for i in range(6):
        arr.append([])
        for _ in range(50):
            arr[i].append(".")

    lines = open(input_file, 'r').readlines()
    for line in lines:
        if line.startswith("rect"):
            width, height = map(int, re.search(r"(\d+)x(\d+)",line).groups())
            arr = rect(arr, width, height)
        elif line.startswith("rotate row"):
            idx, times = map(int, re.search(r"y=(\d+) by (\d+)",line).groups())
            arr = rotate(arr, idx, times)
        else:
            idx, times = map(int, re.search(r"x=(\d+) by (\d+)",line).groups())
            arr = transpose(rotate(transpose(arr), idx, times))

    count = 0
    for row in arr:
        print("".join(row))
        for cell in row:
            if cell == "#":
                count += 1
    print(count)


def rect(arr, width, height):
    for y in range(height):
        for x in range(width):
            arr[y][x] = "#"
    return arr

def rotate(arr, idx, times):
    for _ in range(times):
        arr[idx] = arr[idx][-1:] + arr[idx][:-1]
    return arr

def transpose(arr):
    return list(map(list, zip(*arr)))

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
