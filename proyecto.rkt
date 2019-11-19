#|
    Matrix Multiplication in Racket
    valid extensions: .rkt or .scm

    Aarón Zajac Hadid
    A01023376

    Alejandra Tubilla Castellanos
    A01022960
|#

(define (read_file)
  (let
    ;Read from file and convert to list
    ([listF (file->list "matriz.txt")])
    ;Get the number of rows in the first matrix
    (define row1 (list-ref listF 0))
    ;Get the number of columns in the first matrix
    (define col1 (list-ref listF 1))
    ;Get index to know where to divide the lists
    (define indexL (+ 2 (* row1 col1)))
    ;Get the number of rows in the second matrix
    (define row2 (list-ref listF indexL))
    ;Get the number of columns in the second matrix
    (define col2 (list-ref listF (+ 1 indexL)))
    ;Split the list with all the information into the separate matrix
    (let-values (((list1 list2) (split-at listF indexL)))

        ;Get only the elements of the matrix
        (define firstM  (cdr (cdr list1)))
        (define secondM (cdr (cdr list2)))
        
        ;Form first matrix
        (define Matrix1 
        (let-values (((part1 part2) (split-at firstM row1)))
          (list part1 part2)
        ))

        ;Form second matrix
        (define Matrix2
        (let-values (((part1 part2) (split-at secondM row2)))
          (list part1 part2)
        ))

        (display "Matrix 1: ")
        (displayln Matrix1)

        (display "Matrix 2: ")
        (displayln Matrix2)

        (display "Result: ")
        (m-mult Matrix1 Matrix2)
      )
  )
)


;(call-with-input-file "matriz.txt" read_file)

(define (m-mult Matrix1 Matrix2)
  (for/list ([r Matrix1])
    (for/list ([c (apply map list Matrix2)])
      (apply + (map * r c)))))

; (m-mult '((1 2) (3 4)) '((5 6) (7 8)))
