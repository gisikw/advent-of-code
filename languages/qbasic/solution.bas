INPUT_FILE$ = peek$("argument")
PART$ = peek$("argument")


OPEN INPUT_FILE$ FOR READING AS #1
LINES = 0
WHILE NOT EOF(1)
    LINE INPUT #1 L$
    LINES = LINES + 1
WEND
CLOSE #1

PRINT "Received ", LINES, " lines of input for part ", PART$
