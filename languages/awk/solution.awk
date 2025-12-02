BEGIN {
    lines = 0
}
{
    lines++
}
END {
    printf "Received %d lines of input for part %s\n", lines, part
}
