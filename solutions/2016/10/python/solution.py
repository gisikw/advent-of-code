import sys
import re

def main(input_file, part):
    held, inst, outputs = {}, {}, {}
    for line in open(input_file, 'r'):
        nums = list(map(int,re.findall(r"\d+",line)))
        if line.startswith("value"):
            if nums[1] not in held:
                held[nums[1]] = []
            held[nums[1]].append(nums[0])
        else:
            inst[nums[0]] = list(map(lambda s: s.split(),re.findall(r"(?<=[^|])(?:bot|output) \d+",line)))

    while (item := next(filter(lambda kv: len(kv[1]) == 2, held.items()), None)) is not None:
        bot, bits = item
        bits = sorted(bits)
        if bits == [17, 61] and part == "1":
            print(bot)
            return
        del held[bot]
        for i in range(2):
            idx = int(inst[bot][i][1])
            if inst[bot][i][0] == "bot":
                if idx not in held:
                    held[idx] = []
                held[idx].append(bits[i])
            else:
                if idx not in outputs:
                    outputs[idx] = []
                outputs[idx].append(bits[i])

    print(outputs[0][0] * outputs[1][0] * outputs[2][0])

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
