DO (5050) NEXT

DO .4 <- #3
DO .5 <- #0
(10) DO COME FROM (20)
DO .6 <- ,1 SUB .4
DO ABSTAIN !6~#256' FROM (10)

DO .1 <- .5
DO (1020) NEXT
DO .5 <- .1

DO .1 <- .5
DO :2 <- "'?.6$#10'~'#0$#65535'"
DO .2 <- ':2~:2'~#1
DO (1010) NEXT
DO .5 <- .3

DO .1 <- .4
DO (1020) NEXT
(20) DO .4 <- .1

DO .1 <- .5
PLEASE DON'T FORGET: increment by one less because of EOF newline
DO .2 <- #47
DO (1000) NEXT

DO ,2 <- #65535
PLEASE DO ,2 SUB #1 <- #82
PLEASE DO ,2 SUB #2 <- #101
PLEASE DO ,2 SUB #3 <- #99
PLEASE DO ,2 SUB #4 <- #101
PLEASE DO ,2 SUB #5 <- #105
PLEASE DO ,2 SUB #6 <- #118
PLEASE DO ,2 SUB #7 <- #101
PLEASE DO ,2 SUB #8 <- #100
PLEASE DO ,2 SUB #9 <- #32
DO ,2 SUB #10 <- .3
DO ,2 SUB #11 <- #32
DO ,2 SUB #12 <- #108
DO ,2 SUB #13 <- #105
DO ,2 SUB #14 <- #110
DO ,2 SUB #15 <- #101
DO ,2 SUB #16 <- #115
DO ,2 SUB #17 <- #32
DO ,2 SUB #18 <- #111
DO ,2 SUB #19 <- #102
DO ,2 SUB #20 <- #32
DO ,2 SUB #21 <- #105
DO ,2 SUB #22 <- #110
DO ,2 SUB #23 <- #112
DO ,2 SUB #24 <- #117
DO ,2 SUB #25 <- #116
DO ,2 SUB #26 <- #32
DO ,2 SUB #27 <- #102
DO ,2 SUB #28 <- #111
DO ,2 SUB #29 <- #114
DO ,2 SUB #30 <- #32
DO ,2 SUB #31 <- #112
DO ,2 SUB #32 <- #97
DO ,2 SUB #33 <- #114
DO ,2 SUB #34 <- #116
DO ,2 SUB #35 <- #32
DO ,2 SUB #36 <- ,1 SUB #1
DO ,2 SUB #37 <- #10
DO ,2 SUB #38 <- #256
DO (5000) NEXT

PLEASE GIVE UP

PLEASE DON'T --------------------------------------------------
PLEASE DON'T write out a 256-sentineled character array from ,2
PLEASE DON'T --------------------------------------------------
PLEASE DON'T .5000 index, .5001 tape head, .5002 value, ,5000 sub #1 write buffer
(5000) DO .5000 <- #1
DO ,5000 <- #1

PLEASE DON'T loop until we see 256
(5005) DO COME FROM (5040)
DO .5002 <- ,2 SUB .5000
DO ABSTAIN !5002~#256' FROM (5005)

PLEASE DON'T flip 8 bits
DO .5002 <- !5002~#15'$!5002~#240'
DO .5002 <- !5002~#15'$!5002~#240'
DO .5002 <- !5002~#15'$!5002~#240'

PLEASE DON'T add 256 if needed to wrap
DO .1 <- '?.5002$.5001'~'#0$#65535'
DO .1 <- '&"'.5002~.1'~'"?'?.1~.1'$#32768"
                ~"#0$#65535"'"$".1~.1"'~#1
DO .2 <- #256
DO (1030) NEXT
DO .1 <- .3
DO .2 <- .5001
DO (1000) NEXT

PLEASE DON'T subtract flipped bits
DO .1 <- .3
DO .2 <- .5002
DO (1010) NEXT
DO ,5000 SUB #1 <- .3
DO .5001 <- .5002

PLEASE DON'T increment array index
DO .1 <- .5000
DO (1020) NEXT
DO .5000 <- .1

(5040) DO READ OUT ,5000
DO RESUME #1

PLEASE DON'T ----------------------------------------------
PLEASE DON'T read a 256-sentineled character array into ,1
PLEASE DON'T ----------------------------------------------
(5050) DO ,1 <- #65535
DO ,5050 <- #1
DO .5051 <- #1
(5055) DO COME FROM (5080)
DO WRITE IN ,5050
DO .5050 <- ,5050 SUB #1
DO ABSTAIN !5050~#256' FROM (5055)

PLEASE DON'T travel the increment
DO .1 <- .5050
DO .2 <- .5052
DO (1000) NEXT
DO .5052 <- .3

PLEASE DON'T subtract 256 if needed to wrap
DO .1 <- !3~#256'
DO .2 <- #256
DO (1030) NEXT
DO .1 <- .5052 
DO .2 <- .3
DO (1010) NEXT
DO .5052 <- .3
DO ,1 SUB .5051 <- .5052

PLEASE DON'T increment array index and save values
DO .1 <- .5051
DO (1020) NEXT
(5080) DO .5051 <- .1
DO ,1 SUB .5051 <- #256
DO RESUME #1
