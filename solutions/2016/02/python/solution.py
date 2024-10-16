import sys

dirs = { "U": -1, "R": 1j, "D": 1, "L": -1j }
def main(input_file, part):
    answer, pos = "", 1 + 1j
    buttons = [ 
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ]

    if part == "2":
        pos = 2 + 2j
        buttons = [
            [0,0,1,0,0],
            [0,2,3,4,0],
            [5,6,7,8,9],
            [0,"A","B","C",0],
            [0,0,"D",0,0]
        ]

    with open(input_file, 'r') as file:
        for line in file.readlines():
            for step in line.rstrip():
                new_pos = pos + dirs[step]
                real, imag = int(new_pos.real), int(new_pos.imag)
                if (0 <= real < len(buttons) and 
                    0 <= imag < len(buttons) and 
                    buttons[real][imag] != 0):
                    pos = new_pos
            answer = answer + str(buttons[int(pos.real)][int(pos.imag)])

    print(answer)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
