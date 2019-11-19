#|
    Matrix Multiplication in Racket
    valid extensions: .rkt or .scm

    Aarón Zajac Hadid
    A01023376

    Alejandra Tubilla Castellanos
    A01022960
|#

;Needed libraries
(require htdp/matrix)
(require math/matrix)

(define (read_file)
  ;(display "Enter the name of the file you will like to use as input (matrix.txt): ")
  ;(define file (read))
  (let
    ;Read from file and convert to list
    ([listF (file->list "matrix2.txt")])
       ;(displayln listF)
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

      ;(display "Row 1: ")
      ;(displayln row1)
      ;(display "Col 1: ")
      ;(displayln col1)
      ;(display "Row 2: ")
      ;(displayln row2)
      ;(display "Col 2: ")
      ;(displayln col2)

    ;Split the list with all the information into the separate matrix
    (let-values (((list1 list2) (split-at listF indexL)))
    ;Get only the elements of the matrix
        (define firstM  (cdr (cdr list1)))
        (define secondM (cdr (cdr list2)))
        
        ;Create matrix
        (define Matrix1 (list->matrix row1 col1 firstM))
        (define Matrix2 (list->matrix row2 col2 secondM))
        
        ;Convert matrix to list of list to do the math
        (define MatrixList1 (matrix->list* Matrix1))
        (define MatrixList2 (matrix->list* Matrix2))

        ;Display the matrix and results
        (displayln "First matrix: ")
        (displayln MatrixList1)
        (displayln "Second matrix: ")
        (displayln MatrixList2) 
        (displayln "Matrix Result: ")
        
        ;Call the multiplication function
        (MultiplyMatrix MatrixList1 MatrixList2)
    )
  )
)


;(call-with-input-file "matriz.txt" read_file)

(define (MultiplyMatrix Matrix1 Matrix2)
  (for/list ([r Matrix1])
    (for/list ([c (apply map list Matrix2)])
      (apply + (map * r c)))))

