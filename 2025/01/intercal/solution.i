        DO (5050) NEXT

        PLEASE DON'T FORGET: .14 is array index, .15 is the rotation value
        PLEASE DON'T FORGET: .16 is the seen count, .26 is part 2 seen count
        DO .14 <- #3
        DO .15 <- #1050
        DO .16 <- #0

        PLEASE DON'T FORGET: .17 = L/R, .18 = num
        DO .17 <- ,1 SUB .14
(100)   DO COME FROM (200)

        DO .1 <- .14
        DO (1020) NEXT
        DO .14 <- .1

        DO .1 <- ,1 SUB .14
        DO .2 <- #48
        DO (1010) NEXT
        DO .18 <- .3
(110)   DO COME FROM (120) AGAIN

        PLEASE DON'T FORGET: base10 left shift .18
        DO .1 <- .18
        DO .2 <- #10
        DO (1030) NEXT
        DO .18 <- .3

        PLEASE DON'T FORGET: increment buffer index, and convert to int
        DO .1 <- .14
        DO (1020) NEXT
        DO .14 <- .1

        DO .5101 <- ,1 SUB .14
        DO .5102 <- #10
        DO (5110) NEXT
        DO ABSTAIN .5100 FROM (110)

        DO .1 <- ,1 SUB .14
        DO .2 <- #48
        DO (1010) NEXT

        PLEASE DON'T FORGET: zero it out if it's an overflow
        DO .1 <- '?#256$.3'~'#0$#65535'
        DO .1 <- '&"'#256~.1'~'"?'?.1~.1'$#32768"
                        ~"#0$#65535"'"$".1~.1"'~#1
        DO .2 <- .3
        DO (1030) NEXT

        DO .1 <- .18
        PLEASE DO .2 <- .3
        DO (1000) NEXT
        DO .18 <- .3

(120)   PLEASE DON'T STOP LOOPING

        DO .1 <- .18
        DO .2 <- #10
        PLEASE DO (1040) NEXT
        DO .18 <- .3

        PLEASE DON'T FORGET: solve the actual problem here

        PLEASE DON'T FORGET: we need to snag the pre-mutated position for part 2
        DO .27 <- .15

        PLEASE DON'T FORGET: .19 is the subtract term, zeroed if it's useless
        DO .5101 <- .17
        DO .5102 <- #76
        DO (5110) NEXT
        DO .25 <- .5100
        DO .1 <- .15
        DO .2 <- .18
        DO (1010) NEXT
        DO .1 <- .3
        DO .2 <- .5100
        DO (1030) NEXT
        DO .19 <- .3

        PLEASE DON'T FORGET: now the add term, zeroed if it's useless
        DO .1 <- .15
        DO .2 <- .18
        DO (1000) NEXT
        DO .1 <- .3
        DO .2 <- '?".5100$#1"'~#1
        DO (1030) NEXT
        
        PLEASE DON'T FORGET: now we just add the terms. Who needs conditionals?
        DO .1 <- .19
        DO .2 <- .3
        DO (1000) NEXT
        DO .15 <- .3

        PLEASE DON'T FORGET: to strip off the 100 prefix
        DO .1 <- .3
        DO .2 <- #100
        DO (1040) NEXT
        DO .1 <- .3
        DO .2 <- #100
        DO (1030) NEXT
        DO .1 <- .15
        DO .2 <- .3
        DO (1010) NEXT
        DO .15 <- .3
        DO .40 <- .15
        PLEASE DON'T READ OUT .15

        DO .5101 <- .3
        DO .5102 <- #0
        DO (5110) NEXT
        DO .1 <- .16
        DO .2 <- .5100
        DO (1000) NEXT
        DO .16 <- .3

        PLEASE DON'T FORGET: to put it back
        DO .1 <- .15
        DO .2 <- #1000
        DO (1000) NEXT
        DO .15 <- .3

        PLEASE DON'T FORGET: now for the part two logic

        PLEASE DON'T FORGET: calculate the distance to the zero based on direction
        DO .1 <- .27
        DO .2 <- #100
        DO (1040) NEXT
        DO .1 <- .3
        DO .2 <- #100
        DO (1030) NEXT
        DO .1 <- .27
        DO .2 <- .3
        DO (1010) NEXT
        DO .29 <- .3
        
        PLEASE DON'T FORGET: the leftward distance, zeroed out if we're not going left
        DO .1 <- .29
        DO .2 <- .25
        DO (1030) NEXT
        DO .30 <- .3

        PLEASE DON'T FORGET: the rightward distance, zeroed out if we're not going left
        DO .1 <- #100
        DO .2 <- .29
        DO (1010) NEXT

        DO .1 <- .3
        DO .2 <- '?".25$#1"'~#1
        DO (1030) NEXT

        DO .1 <- .3
        DO .2 <- .30
        DO (1000) NEXT
        DO .30 <- .3

        PLEASE DON'T FORGET: now we have the minimum distance needed to travel to cause one click

        DO .1 <- '?.30$.18'~'#0$#65535'
        DO .1 <- '&"'.30~.1'~'"?'?.1~.1'$#32768"
                        ~"#0$#65535"'"$".1~.1"'~#1
        DO .1 <- '?".1$#1"'~#1
        DO .5101 <- .30
        DO .5102 <- #0
        DO (5100) NEXT
        DO .2 <- .5100
        DO (1030) NEXT

        DO .1 <- .26
        DO .2 <- .3
        DO (1000) NEXT
        DO .26 <- .3

        PLEASE DON'T FORGET: and we can calculate multiclicks by subtracting distance and dividing
        DO .1 <- .18
        DO .2 <- .30
        DO (1010) NEXT

        PLEASE DON'T FORGET: zero it out if it's an overflow
        DO .1 <- '?#1000$.3'~'#0$#65535'
        DO .1 <- '&"'#1000~.1'~'"?'?.1~.1'$#32768"
                        ~"#0$#65535"'"$".1~.1"'~#1
        DO .2 <- .3
        DO (1030) NEXT

        DO .1 <- .3
        PLEASE DO .2 <- #100
        DO (1040) NEXT

        DO .1 <- .26
        DO .2 <- .3
        PLEASE DO (1000) NEXT
        DO .26 <- .3

        DO .1 <- .14
        DO (1020) NEXT
        DO .14 <- .1

        DO .17 <- ,1 SUB .14
        PLEASE DON'T FORGET: \n\n or EOF
        DO ABSTAIN !17~#256' FROM (100)
        DO .5101 <- .17
        PLEASE DO .5102 <- #10
        DO (5110) NEXT
        DO ABSTAIN .5100 FROM (100)
(200)   PLEASE DON'T STOP LOOPING

        PLEASE DON'T: forget to override .16 with .26 if part 2
        DO .1 <- ,1 SUB #1
        PLEASE DO .2 <- #49
        DO (1010) NEXT
        DO .50 <- .3

        DO .1 <- .3
        DO .2 <- .26
        PLEASE DO (1030) NEXT
        DO .52 <- .3

        DO .1 <- '?".50$#1"'~#1
        DO .2 <- .16
        DO (1030) NEXT
        DO .51 <- .3

        DO .1 <- .51
        PLEASE DO .2 <- .52
        PLEASE DO (1000) NEXT
        DO .16 <- .3

        PLEASE DON'T: forget to turn a number into a string. Painfully.
        DO ,3 <- #65535
        DO .20 <- #1

(300)   DO COME FROM (400)
        DO .1 <- .16
        DO .2 <- #10
        DO (1040) NEXT
        DO .21 <- .3

        DO .1 <- .3
        DO .2 <- #10
        DO (1030) NEXT

        DO .5101 <- .3
        PLEASE DO .5102 <- #0
        DO (5110) NEXT
        DO ABSTAIN .5100 FROM (300)

        DO .1 <- .16
        DO .2 <- .3
        DO (1010) NEXT
        DO .16 <- .3

        DO .1 <- .16
        DO .2 <- #48
        PLEASE DO (1000) NEXT
        DO ,3 SUB .20 <- .3

        DO .16 <- .21

        DO .1 <- .20
        DO (1020) NEXT
        DO .20 <- .1
(400)   PLEASE DON'T STOP LOOPING

        DO ,2 <- #65535
        DO .21 <- #1
(500)   DO COME FROM (600)

        DO .5101 <- .20
        PLEASE DO .5102 <- #1
        DO (5110) NEXT
        DO ABSTAIN .5100 FROM (500)

        PLEASE DO ,2 SUB .21 <- ,3 SUB .20

        DO .1 <- .20
        DO .2 <- #1
        PLEASE DO (1010) NEXT
        DO .20 <- .3

        DO .1 <- .21
        DO (1020) NEXT
        DO .21 <- .1

(600)   PLEASE DON'T STOP LOOPING

        DO ,2 SUB .21 <- #10
        DO .1 <- .21
        DO (1020) NEXT
        DO ,2 SUB .1 <- #256
        DO (5000) NEXT
        PLEASE GIVE UP

PLEASE DON'T --------------------------------------------------
PLEASE DON'T write out a 256-sentineled character array from ,2
PLEASE DON'T --------------------------------------------------
(5000)  DO .5000 <- #1
        DO ,5000 <- #1

        PLEASE DON'T loop until we see 256
(5005)  DO COME FROM (5040)
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

(5040)  DO READ OUT ,5000
        DO RESUME #1

PLEASE DON'T ----------------------------------------------
PLEASE DON'T read a 256-sentineled character array into ,1
PLEASE DON'T ----------------------------------------------
(5050)  DO ,1 <- #65535
        DO ,5050 <- #1
        DO .5051 <- #1
(5055)  DO COME FROM (5080)
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
(5080)  DO .5051 <- .1
        DO ,1 SUB .5051 <- #256
        DO RESUME #1

PLEASE DON'T ------------------------------------------------------------
PLEASE DON'T set an inequality flag in .5100 by comparing .5101 and .5102
PLEASE DON'T ------------------------------------------------------------
(5100)  DO :5100 <- "'?.5101$.5102'~'#0$#65535'"
        DO .5100 <- ':5100~:5100'~#1
        DO RESUME #1

PLEASE DON'T ----------------------------------------------------------
PLEASE DON'T set an equality flag in .5100 by comparing .5101 and .5102
PLEASE DON'T ----------------------------------------------------------
(5110)  DO (5100) NEXT
        DO .5100 <- '?".5100$#1"'~#1
        DO RESUME #1
