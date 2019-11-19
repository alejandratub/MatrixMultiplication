#|
    Matrix Multiplication in Racket
    valid extensions: .rkt or .scm

    Aarón Zajac Hadid
    A01023376

    Alejandra Tubilla Castellanos
    A01022960
|#
(require htdp/matrix)
  
(define (read_file )
  (let
    ;Read from file and convert to list
    ([listF (file->list "matriz.txt")])
    (displayln listF)
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

    (display "Row 1: ")
      (displayln row1)
      (display "Col 1: ")
      (displayln col1)
      (display "Row 2: ")
      (displayln row2)
      (display "Col 2: ")
      (displayln col2)
    ;Split the list with all the information into the separate matrix
    (let-values (((list1 list2) (split-at listF indexL)))

        ;Get only the elements of the matrix
        (define firstM  (cdr (cdr list1)))
        (define secondM (cdr (cdr list2)))
      


          
        (display "First matrix: ")
        (displayln firstM)
        (display "First matrix: ")
        (displayln secondM)

      ;Create matrix from list 
      (define Matrix1 (make-matrix row1 col1 firstM))
      (define Matrix2 (make-matrix row2 col2 secondM))
      (matrix-render Matrix1)
      ;(matrix-render Matrix2)
    
      
      )
       
  
    
      

    
  )
)


;(call-with-input-file "matriz.txt" read_file)

(define (m-mult m1 m2)
  (for/list ([r m1])
    (for/list ([c (apply map list m2)])
      (apply + (map * r c)))))

; (m-mult '((1 2) (3 4)) '((5 6) (7 8)))
