#|
Matrix Multiplication in Racket
    valid estensions: .rkt or .scm

    Aarón Zajac Hadid
    A01023376

    Alejandra Tubilla
    A01022960
|#


; #lang racket
;Read File line by line
(define (read_file file)
  (let ((line (read-line file 'any)))
    (unless (eof-object? line)
    ;   (displayln line)
      (read_file file))))




(define (m-mult m1 m2)
  (for/list ([r m1])
    (for/list ([c (apply map list m2)])
      (apply + (map * r c)))))

; (m-mult '((1 2) (3 4)) '((5 6) (7 8)))

