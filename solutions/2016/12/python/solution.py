import sys

def main(input_file, part):
    instructions = open(input_file, 'r').readlines()
    registers = {"a":0,"b":0,"c":0,"d":0}
    pc = 0

    if part == "2":
        registers["c"] = 1

    while pc < len(instructions):
        parts = instructions[pc].split()
        inst = parts[0]
        x = parts[1]
        if len(parts) > 2:
            y = parts[2]
        if inst == "cpy":
            registers[y] = resolve(x, registers)
        elif inst == "inc":
            registers[x] += 1
        elif inst == "dec":
            registers[x] -= 1
        elif inst == "jnz":
            if resolve(x, registers) != 0:
                pc += resolve(y, registers) - 1
        pc += 1

    print(resolve("a", registers))

def resolve(value, registers):
    try:
        return int(value)
    except ValueError:
        return registers[value]

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
