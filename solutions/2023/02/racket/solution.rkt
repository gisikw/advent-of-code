#lang racket

(define (main)
  (define args (vector->list (current-command-line-arguments)))
    (let ([input-file (list-ref args 0)]
          [part (list-ref args 1)])
      (if (string=? part "1")
          (part1 input-file)
          (part2 input-file))))

(define (part1 input-file)
  (let* ([lines (for/list ([line (in-lines (open-input-file input-file))]) line)]
         [games (map parse-game lines)])
    (printf "~a\n" (for/sum ([id (map car (filter meets-part-1-minimums games))]) id))))

(define (parse-game line)
  (match (string-split line ":") 
    [(list game-string cubes-string)
     (cons 
       (parse-game-id game-string) 
       (parse-revealed-cubes cubes-string))]))

(define (parse-game-id game-string)
  (string->number (second (string-split game-string))))

(define (parse-revealed-cubes cubes-string)
  (let* ([pull-strings (string-split cubes-string ";")]
         [pull-results (apply append (map parse-pull-string pull-strings))])
    (list
      (max-of-color pull-results "red")
      (max-of-color pull-results "green")
      (max-of-color pull-results "blue"))))

(define (parse-pull-string pull-string)
  (let ([pair-strings (string-split pull-string ",")])
    (map parse-pair-string pair-strings)))

(define (parse-pair-string pair-string)
  (match (string-split pair-string " ")
    [(list num color)
     (list (string->number num) color)]))

(define (max-of-color all-pairs color)
  (let ([pairs (filter (lambda (pair) (string=? (second pair) color)) all-pairs)])
    (apply max (map first pairs))))

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
                    (parse-game line))])
    (printf "~a\n" (for/sum ([power (map game-power games)]) power))))

(define (game-power game)
  (* (red game) (green game) (blue game)))

(main)
