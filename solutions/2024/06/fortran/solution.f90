program Solution
    implicit none
    character(len=256) :: inputFileName, part
    integer :: lineCount, iostat
    character :: grid(130,130), grid_copy(130,130)
    character(len=130) :: line
    integer :: unit
    integer :: r, c, start_row, start_col
    integer :: row, col, dir, sum

    call GET_COMMAND_ARGUMENT(1, inputFileName)
    call GET_COMMAND_ARGUMENT(2, part)

    unit = 10

    open(unit=unit, file=trim(inputFileName), status='old', action='read', iostat=iostat)
    do r = 1, 130
        read(unit, '(A)', iostat=iostat) line
        if (iostat /= 0) exit
        do c = 1, 130
            grid(r,c) = line(c:c)
            if (line(c:c) == "^") then
                start_col = c
                start_row = r
            end if
        end do
    end do
    close(unit)

    row = start_row
    col = start_col
    dir = 1
    do
        grid(row,col) = "X"
        select case (dir)
            case (1)
                r = row - 1
                c = col
            case (2)
                c = col + 1
                r = row
            case (3)
                r = row + 1
                c = col
            case (4)
                c = col - 1
                r = row
        end select

        if (r < 1 .OR. r > 130 .OR. c < 1 .OR. c > 130) exit

        if (grid(r,c) == "#") then
            dir = dir + 1
            if (dir > 4) dir = 1
        else
            row = r
            col = c
        end if
    end do

    if (part == "1") then
        do r = 1, 130
            do c = 1, 130
                if (grid(r,c) == "X") sum = sum + 1
            end do
        end do
    else
        do r = 1, 130
            do c = 1, 130
                if (grid(r,c) == "X") then
                    grid_copy = grid
                    grid_copy(r,c) = "#"
                    if (loops(grid_copy, start_row, start_col)) sum = sum + 1
                end if
            end do
        end do
    end if

    print '(I0)', sum

contains

    pure function loops(grid_copy, start_row, start_col) result(out)
        character, intent(in) :: grid_copy(130,130)
        character :: grid(130,130)
        integer, intent(in) :: start_row, start_col
        integer :: r, c, row, col, dir, i
        logical :: out
        out = .TRUE.
        grid = grid_copy
        row = start_row
        col = start_col
        dir = 1
        do i = 1, 10000
            select case (dir)
                case (1)
                    r = row - 1
                    c = col
                case (2)
                    c = col + 1
                    r = row
                case (3)
                    r = row + 1
                    c = col
                case (4)
                    c = col - 1
                    r = row
            end select

            if (r < 1 .OR. r > 130 .OR. c < 1 .OR. c > 130) then
                out = .FALSE.
                exit
            end if

            if (grid(r,c) == "#") then
                dir = dir + 1
                if (dir > 4) dir = 1
            else
                row = r
                col = c
            end if
        end do
    end function

end program Solution
