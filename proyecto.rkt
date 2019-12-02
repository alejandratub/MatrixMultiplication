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

(define matriz_final '())

; Create a channel for the work list
(define channel-work (make-channel))
; Create a channel for the output
(define channel-out (make-channel))

(define (matrixMultiplication)
  (displayln "...::WELCOME TO THE MATRIX MULTIPLICATION PROGRAM::...")
  (displayln "The program recieves as input a text file with two matrices and multiplies them by parts using threads.\n")
  (display "Enter the name of the file you will like to use as input 'matrix.txt': ")
  (define file (read))
  (let
    ;Read from file and convert to list
    ([listF (file->list file)])
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

     (cond 
        [ (not (= col1 row2)) (display "The number of columns of the first matrix must be the same as the number of rows of the second matrix")] 
        
        [

          ;Split the list with all the information into the separate matrix
          (let-values (((list1 list2) (split-at listF indexL)))

          ;Get only the elements of the matrix
          (define firstMatrixElements  (cdr (cdr list1)))
          (define secondMatrixElements (cdr (cdr list2)))
          
          ;Create matrix
          (define Matrix1 (list->matrix row1 col1 firstMatrixElements))
          (define Matrix2 (list->matrix row2 col2 secondMatrixElements))
          
          ;Convert matrix to list of list to do the math
          (define MatrixList1 (matrix->list* Matrix1))
          (define MatrixList2 (matrix->list* Matrix2))

          ;Display the matrix and results
          (displayln "First matrix: ")
          (displayln  MatrixList1)
          (displayln "Second matrix: ")
          (displayln MatrixList2) 
          (displayln "Matrix Result: ")

          (define threads (map make-worker '(One Two Three Four)))
          ; (define count (0))
          ; (displayln count)
          (let*
            ( 
              [data (append MatrixList1 '(end end))]
              [n 0]  
            )
              (for-each (lambda (message) 
                ; (count (+ 1 count))
                ; (display count)
                (define row (append (list message) MatrixList2))
                (set! n (add1 n))
                ; (displayln (format "~a / ~a" row n))
                (channel-put channel-work (list row n))) data)

            ;wait for the threads to finish
            (for-each thread-wait threads))
      )
        ])
))


; THREAD FUNCTION
(define (MultiplyMatrix row Matrix2)
    ;multiply each column by the row
    (for/list ([column (apply map list Matrix2)])
      (apply + (map * row column))))

; Create the thread to post the output
(thread (lambda ()
         (let loop
            ()
            (define row (channel-get channel-out))
            ; (if )
            ; (main matriz_final row)
            ; (append matriz_final row)
            ; (displayln matriz_final)
             ; (define matrix '())
            ; (displayln (equal? (car (car (cdr row))) 1))
            ; (if (equal? (car (car (cdr row))) 1)
            ; ; (if (equal? 1 1)
            ; 	(displayln (car row))
            ; 	(displayln "-")
            ; )
            ; (define matrix (row))
            ; (displayln row)
            (loop))))


; Function to generate threads for processing
(define (make-worker name)
    (thread (lambda ()
         (let loop
            ()
            (define message (channel-get channel-work))
            ; (displayln (cdr (car message)))
            (case (car (car message))
                [(end)
                      (displayln "End")]
                    ; (channel-put channel-out (format "Thread ~a finishing" name))]
                [else
                    (define result (MultiplyMatrix (car (car message)) (cdr (car message))))
                    ; (displayln (list result (cdr message)))
                    ; (channel-put channel-out (format "Thread ~a: n = ~a" name message))
                    (channel-put channel-out (list (cdr message) result))
                    (loop)])))))


(define (sort-by-car-number lst) 
(define (object-greater? a b)
(<= (car (car a) ) (car (car b))))
(sort lst object-greater?)) 