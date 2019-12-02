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

(define length 4)

; Create a channel for the work list
(define channel-work (make-channel))
; Create a channel for the output
(define channel-out (make-channel))

(define channel-result (make-channel))

;main function
(define (matrixMultiplication)
  (displayln "...::WELCOME TO THE MATRIX MULTIPLICATION PROGRAM::...")
  (displayln "The program recieves as input a text file with two matrices and multiplies them by parts using threads.\n")
  (display "Enter the name of the file you will like to use as input 'matrix.txt': ")
  (define file (read))
  (let
    ;Read from file and convert to list
    ([listF (file->list file)])

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
          (displayln "\n First matrix:\n ")
          (printMatrix  MatrixList1)
          (displayln "\nSecond matrix: \n")
          (printMatrix MatrixList2) 
          (displayln "\nMatrix Result: \n")

          (define threads (map make-worker '(One Two Three Four)))
          
          (let*
            ( 
              [data (append MatrixList1 '(end end end end))]
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
(thread 
  (lambda ()
    (let loop
      ( 
        [matriz_final empty]
        [n 1]
      )
      (define row (channel-get channel-out))
          (if (equal? (car row) "End")
            (
              (if (equal? n length)
                (
                    (displayln "Out")
                    ; (displayln (indexSort (matriz_final)))
                    (channel-put channel-result (list matriz_final))
                )
                  (loop (list matriz_final) (+ n 1))
              )
            )
             (loop (append matriz_final (list row)) n)
              ; ((loop (append matriz_final row) n))
        )  
    )
  )
)


; Function to generate threads for processing
(define (make-worker name)
    (thread (lambda ()
         (let loop
            ()
            (define message (channel-get channel-work))
            ; (displayln (cdr (car message)))
            (case (car (car message))
                [(end)
                    ; (displayln "End")]
                    (channel-put channel-out (list "End"))]
                [else
                    (define result (MultiplyMatrix (car (car message)) (cdr (car message))))
                    ; (displayln (list result (cdr message)))
                    ; (channel-put channel-out (format "Thread ~a: n = ~a" name message))
                    (channel-put channel-out (list (cdr message) result))
                    (loop)])))))


;Sort result to correctly build the resulting matrix
(define (indexSort lst) 
  (define (greater? a b)
     (<= (car (car a) ) (car (car b)))
  )
  (define orderedMatrix (sort lst greater?) )
  (printMatrix  orderedMatrix)
  (display "\n")
  (removeIndex orderedMatrix)
)

(define (removeIndex lst )
  (for ([e (in-list lst)])
    (displayln  (car (cdr e)))
  )
)

(thread (lambda ()
         (let loop
            ([n 0])
            (define matriz (channel-get channel-result))
            (if (equal? n 1)
              (displayln "Done")
              (
                (displayln n)
                (indexSort (car (car (car (car matriz)))))
                (loop (+ n 1))
              )
            )
)))