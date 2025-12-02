(define input-file (cadr (command-line)))
(define part (caddr (command-line)))

(define (skip-to-newline port)
  (let ((ch (read-char port)))
    (cond ((eof-object? ch) #f)
          ((char=? ch #\newline) #t)
          (else (skip-to-newline port)))))

(define (count-lines port)
  (if (skip-to-newline port)
      (+ 1 (count-lines port))
      0))

(define lines
  (call-with-input-file input-file count-lines))

(display (string-append "Received "
                        (number->string lines)
                        " lines of input for part "
                        part
                        "\n"))
