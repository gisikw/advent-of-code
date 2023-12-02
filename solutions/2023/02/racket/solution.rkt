#lang racket

(define (main)
  (define args (vector->list (current-command-line-arguments)))
    (let ([input-file (list-ref args 0)]
          [part (list-ref args 1)])
      (if (string=? part "1")
          (part1 input-file)
          (part2 input-file))))

(define (part1 input-file)
  (let ([games (for/list ([line (in-lines (open-input-file input-file))]) 
                    (make-game line))])
    (printf "~a\n" (for/sum ([id (map car (filter meets-part-1-minimums games))]) id))))

(define (make-game line)
  (list
    (string->number (second (regexp-match #px"^Game (\\d+)" line)))
    (max-color-count line "red")
    (max-color-count line "green")
    (max-color-count line "blue")
  ))

(define (max-color-count line color)
  (let ([matches (regexp-match* (pregexp (string-append "(\\d+) " color)) line #:match-select values)])
    (if matches
      (apply max (map (lambda (match) (string->number (second match))) matches))
      0)))

(define (meets-part-1-minimums game)
  (and
    (>= 12 (red game))
    (>= 13 (green game))
    (>= 14 (blue game))))

(define (red game) (second game))
(define (green game) (third game))
(define (blue game) (fourth game))

(define (part2 input-file)
  (let ([games (for/list ([line (in-lines (open-input-file input-file))]) 
                    (make-game line))])
    (printf "~a\n" (for/sum ([power (map game-power games)]) power))))

(define (game-power game)
  (* (red game) (green game) (blue game)))

(main)
