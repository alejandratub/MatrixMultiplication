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

; Create a channel for the work list
(define channel-work (make-channel))
; Create a channel for the output
(define channel-out (make-channel))

(define (matrixMultiplication)
  (displayln "...::WELCOME TO THE MATRIX MULTIPLICATION PROGRAM::...")
  (displayln "The program recieves as inputa text file with two matrices and multiplies them by parts using threads.\n")
  (display "Enter the name of the file you will like to use as input (name must be between quotation marks): ")
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
          (displayln "\nFirst matrix: \n")
          (printMatrix MatrixList1)
          (displayln "\nSecond matrix: \n")
          (printMatrix MatrixList2) 
          (displayln "\nMatrix Result: \n")

        (define threads (map make-worker '(One Two)))
          (let*
            ( 
              [data (append MatrixList1 '(end end))])

              (for-each (lambda (message) 
                (define row (append (list message) MatrixList2))
                (channel-put channel-work row )) data)

            ;wait for the threads to finish
            (for-each thread-wait threads))

          ; (flatten MatrixList1)
          (sort-by-index MatrixList1) 
         ; (car (car MatrixList1))

        ;(let-values (((list1 list2) (split-at listF indexL)))

      )
        ])
))


;Ncely print matrix
 (define (printMatrix MatrixList)
          (cond 
            [(null? MatrixList) #f]            
            [else (printf "~s\n" (first MatrixList)) 
                  (printMatrix (rest MatrixList))])) 

; THREAD FUNCTION
(define (MultiplyMatrix row Matrix2)
    ;multiply each column by the row
    (for/list ([column (apply map list Matrix2)])
      (apply + (map * row column))))

; Create the thread to post the output
(thread (lambda ()
         (let loop
            ()
            (displayln (channel-get channel-out))
            (loop))))


; Function to generate threads for processing
(define (make-worker name)
    (thread (lambda ()
         (let loop
            ()
            (define message (channel-get channel-work))
            (case (car message)
                [(end)
                    (channel-put channel-out (format "Thread ~a finishing" name))]
                [else
                    (define result (MultiplyMatrix (car message) (cdr message)))
                    ; (displayln result)
                    (channel-put channel-out (format "Thread ~a: n = ~a | result = ~a" name message result))
                    (loop)])))))