(use-modules (ice-9 rdelim)) 

(define input-file (cadr (command-line)))
(define part (caddr (command-line)))

(define (count-splits count current next)
  (cond 
    ((= 0 (length current)) count)
    ((and
      (char=? (car current) #\|)
      (char=? (car next) #\^))
     (count-splits (+ 1 count) (cdr current) (cdr next)))
    (else (count-splits count (cdr current) (cdr next)))))

(define (update-splits result current next)
  (cond
    ((= 0 (length current))
     (reverse result))
    ((= 1 (length current))
     (reverse (cons (car next) result)))
    ((and
       (char=? (cadr next) #\^)
       (char=? (cadr current) #\|))
     (update-splits
       (cons #\^ (cons #\| result))
       (cddr current)
       (cons #\| (cdddr next))))
    (else (update-splits (cons (car next) result) (cdr current) (cdr next)))))

(define (update-beams result current next)
  (cond
    ((= 0 (length current)) (reverse result))
    ((and
       (char=? (car current) #\|)
       (not (char=? (car next) #\^)))
     (update-beams (cons #\| result) (cdr current) (cdr next)))
    (else (update-beams (cons (car next) result) (cdr current) (cdr next)))))

(define (update-line current next) 
  (update-beams '() current (update-splits '() current next)))

(define (parse-next-line count current port)
  (let ((next-line (read-line port)))
    (cond ((eof-object? next-line) count)
          (else (let ((next (string->list next-line)))
                  (parse-next-line 
                    (count-splits count current next)
                    (update-line current next)
                    port))))))

(define (solve-part-one port)
  (let ((start (map (lambda (c) (cond ((char=? c #\S) #\|) (else c))) 
                    (string->list (read-line port)))))
    (parse-next-line 0 start port)))

(define (read-lines lines port)
  (let ((next-line (read-line port)))
    (cond ((eof-object? next-line) (reverse lines))
          (else (read-lines (cons (string->list next-line) lines) port)))))

(define (cache-get cache row col)
  (let ((r (vector-ref cache row)))
    (cond
      ((unspecified? r) r)
      (else (vector-ref r col)))))

(define (cache-set cache row col val)
  (cond
    ((unspecified? (vector-ref cache row))
     (vector-set! cache row (make-vector 200)))) ; magic number, shame
  (let ((r (vector-ref cache row)))
    (vector-set! r col val)
    val))
 
(define (search lines cache row col)
  (cond ((= row (length lines)) 1)
    (else (let ((cached (cache-get cache row col)))
      (cond
        ((not (unspecified? cached)) cached)
        (else (cache-set cache row col 
          (cond
            ((char=? (list-ref (list-ref lines row) col) #\^)
             (+ (search lines cache (+ row 1) (- col 1))
                (search lines cache (+ row 1) (+ col 1))))
            (else (search lines cache (+ row 1) col))))))))))

(define (solve-part-two port)
  (let* ((lines (read-lines '() port))
         (cache (make-vector (length lines))))
    (search lines cache 0 (/ (- (length (car lines)) 1) 2))))

(define solution
  (cond ((equal? part "1") (call-with-input-file input-file solve-part-one))
        (else (call-with-input-file input-file solve-part-two))))

(display (string-append (number->string solution) "\n"))
