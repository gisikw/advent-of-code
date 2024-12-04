program Solution
    implicit none
    character(len=256) :: inputFileName, part
    integer :: lineCount, iostat
    character(len=256) :: line
    integer :: unit

    call GET_COMMAND_ARGUMENT(1, inputFileName)
    call GET_COMMAND_ARGUMENT(2, part)

    lineCount = 0
    unit = 10

    open(unit=unit, file=trim(inputFileName), status='old', action='read', iostat=iostat)

    do
        read(unit, '(A)', iostat=iostat) line
        if (iostat /= 0) exit
        lineCount = lineCount + 1
    end do

    close(unit)

    print '(A, I0, A, A)', "Received ", lineCount, " lines of input for part ", trim(part)
end program Solution
