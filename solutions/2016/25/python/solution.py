import sys

def main(input_file, part):
    instructions = open(input_file, 'r').readlines()
    a = 0
    while True:
        seq = run(instructions, a)
        if seq == [0,1,0,1,0,1,0,1]:
            print(a)
            return
        a += 1

def run(instructions, a):
    registers = {"a":0,"b":0,"c":0,"d":0}
    pc = 0
    seq = []
    registers["a"] = a

    while pc < len(instructions):
        parts = instructions[pc].split()
        inst = parts[0]
        x = parts[1]
        y = parts[2] if len(parts) > 2 else None
        if inst == "cpy" and y is not None:
            registers[y] = resolve(x, registers)
        elif inst == "inc" and y is None:
            registers[x] += 1
        elif inst == "dec" and y is None:
            registers[x] -= 1
        elif inst == "jnz" and y is not None:
            if resolve(x, registers) != 0:
                pc += resolve(y, registers) - 1
        elif inst == "tgl" and y is None:
            i = resolve(x, registers) + pc
            if 0 < i < len(instructions):
                og_inst = instructions[i].split()
                if len(og_inst) == 2:
                    og_inst[0] = "dec" if og_inst[0] == "inc" else "inc"
                else:
                    og_inst[0] = "cpy" if og_inst[0] == "jnz" else "jnz"
                instructions[i] = " ".join(og_inst)
        elif inst == "out" and y is None:
            seq.append(resolve(x, registers))
            if len(seq) > 7:
                return seq
        pc += 1

def resolve(value, registers):
    try:
        return int(value)
    except ValueError:
        return registers[value]

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
