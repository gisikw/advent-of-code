#lang racket

(define (main)
  (define args (vector->list (current-command-line-arguments)))
    (let ([input-file (list-ref args 0)]
          [part (list-ref args 1)])
      (define lines (for/list ([line (in-lines (open-input-file input-file))])
                       line))
      (printf "Received ~a lines of input for part ~a\n" (length lines) part)))

(main)
