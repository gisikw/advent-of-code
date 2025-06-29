       IDENTIFICATION DIVISION.
       PROGRAM-ID. Solution.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO DYNAMIC-FILE-NAME
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD INPUT-FILE.
       01 INPUT-LINE PIC A(256).

       WORKING-STORAGE SECTION.
       01 DYNAMIC-FILE-NAME PIC X(256).
       01 PART PIC X(256).
       01 END-OF-FILE PIC X VALUE "F".
       01 IDX PIC 9(9) VALUE 1.
       01 XMAS-COUNT PIC 9(9) VALUE 0.
       01 XMAS-COUNT-TEXT PIC Z(9).
       01 CONTENT-STR PIC A(32768).
       01 CONTENT-LEN PIC 9(9) VALUE 1.
       01 LINE-LEN PIC 9(9).

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           ACCEPT DYNAMIC-FILE-NAME
           ACCEPT PART

           PERFORM READ-FILE-TO-STR.
           PERFORM VARYING IDX FROM 1 BY 1 UNTIL IDX = CONTENT-LEN
             IF PART = "1"
               PERFORM COUNT-XMAS
             ELSE
               PERFORM COUNT-X-MAS
             END-IF
           END-PERFORM.

           MOVE XMAS-COUNT TO XMAS-COUNT-TEXT
           DISPLAY FUNCTION TRIM(XMAS-COUNT-TEXT)
           STOP RUN.

       READ-FILE-TO-STR.
           OPEN INPUT INPUT-FILE
           PERFORM UNTIL END-OF-FILE = "T"
             READ INPUT-FILE INTO INPUT-LINE
               AT END
                 MOVE "T" TO END-OF-FILE
               NOT AT END
                 SET LINE-LEN TO 0
                 INSPECT INPUT-LINE 
                   TALLYING LINE-LEN FOR CHARACTERS BEFORE " "
                 MOVE INPUT-LINE TO CONTENT-STR(CONTENT-LEN:LINE-LEN)
                 ADD LINE-LEN TO CONTENT-LEN
           END-PERFORM.
           CLOSE INPUT-FILE.

       COUNT-XMAS.
           IF CONTENT-STR(IDX:1) = "X"
      *> NORTH
             IF (IDX > (LINE-LEN * 3)) AND
               (CONTENT-STR(IDX - LINE-LEN:1) = "M") AND
               (CONTENT-STR(IDX - (LINE-LEN * 2):1) = "A") AND
               (CONTENT-STR(IDX - (LINE-LEN * 3):1) = "S")
               ADD 1 TO XMAS-COUNT
             END-IF
      *> SOUTH
             IF (CONTENT-STR(IDX + LINE-LEN:1) = "M") AND
               (CONTENT-STR(IDX + (LINE-LEN * 2):1) = "A") AND
               (CONTENT-STR(IDX + (LINE-LEN * 3):1) = "S")
               ADD 1 TO XMAS-COUNT
             END-IF

             IF FUNCTION MOD(IDX + LINE-LEN - 1, LINE-LEN) + 1 <
               LINE-LEN - 2
      *> NORTHEAST
               IF (IDX > (LINE-LEN * 3)) AND
                 (CONTENT-STR(IDX - LINE-LEN + 1:1) = "M") AND
                 (CONTENT-STR(IDX - (LINE-LEN * 2) + 2:1) = "A") AND
                 (CONTENT-STR(IDX - (LINE-LEN * 3) + 3:1) = "S")
                 ADD 1 TO XMAS-COUNT
               END-IF
      *> EAST
               IF (CONTENT-STR(IDX + 1:3) = "MAS")
                 ADD 1 TO XMAS-COUNT
               END-IF
      *> SOUTHEAST
               IF (CONTENT-STR(IDX + LINE-LEN + 1:1) = "M") AND
                 (CONTENT-STR(IDX + (LINE-LEN * 2) + 2:1) = "A") AND
                 (CONTENT-STR(IDX + (LINE-LEN * 3) + 3:1) = "S")
                 ADD 1 TO XMAS-COUNT
               END-IF
             END-IF

             IF FUNCTION MOD(IDX + LINE-LEN - 1, LINE-LEN) + 1 > 3
      *> SOUTHWEST
               IF (CONTENT-STR(IDX + LINE-LEN - 1:1) = "M") AND
                 (CONTENT-STR(IDX + (LINE-LEN * 2) - 2:1) = "A") AND
                 (CONTENT-STR(IDX + (LINE-LEN * 3) - 3:1) = "S")
                 ADD 1 TO XMAS-COUNT
               END-IF
      *> WEST
               IF (IDX > 3) AND (CONTENT-STR(IDX - 3:3) = "SAM")
                 ADD 1 TO XMAS-COUNT
               END-IF
      *> NORTHWEST
               IF (IDX > (LINE-LEN * 3) + 2) AND
                 (CONTENT-STR(IDX - LINE-LEN - 1:1) = "M") AND
                 (CONTENT-STR(IDX - (LINE-LEN * 2) - 2:1) = "A") AND
                 (CONTENT-STR(IDX - (LINE-LEN * 3) - 3:1) = "S")
                 ADD 1 TO XMAS-COUNT
               END-IF
             END-IF
           END-IF.

       COUNT-X-MAS.
           IF (CONTENT-STR(IDX:1) = "A") AND
             (IDX > LINE-LEN) AND
             ((FUNCTION MOD(IDX + LINE-LEN - 1, LINE-LEN) + 1) 
               > 1 AND < LINE-LEN)
             EVALUATE CONTENT-STR(IDX - LINE-LEN - 1:1)
               WHEN "M"
                 EVALUATE CONTENT-STR(IDX - LINE-LEN + 1:1)
                   WHEN "M"
                     IF (CONTENT-STR(IDX + LINE-LEN - 1:1) = "S") AND
                        (CONTENT-STR(IDX + LINE-LEN + 1:1) = "S")
                        ADD 1 TO XMAS-COUNT
                     END-IF
                   WHEN "S"
                     IF (CONTENT-STR(IDX + LINE-LEN - 1:1) = "M") AND
                        (CONTENT-STR(IDX + LINE-LEN + 1:1) = "S")
                        ADD 1 TO XMAS-COUNT
                     END-IF
                 END-EVALUATE
               WHEN "S"
                 EVALUATE CONTENT-STR(IDX - LINE-LEN + 1:1)
                   WHEN "M"
                     IF (CONTENT-STR(IDX + LINE-LEN - 1:1) = "S") AND
                        (CONTENT-STR(IDX + LINE-LEN + 1:1) = "M")
                        ADD 1 TO XMAS-COUNT
                     END-IF
                   WHEN "S"
                     IF (CONTENT-STR(IDX + LINE-LEN - 1:1) = "M") AND
                        (CONTENT-STR(IDX + LINE-LEN + 1:1) = "M")
                        ADD 1 TO XMAS-COUNT
                     END-IF
                 END-EVALUATE
             END-EVALUATE
           END-IF.
