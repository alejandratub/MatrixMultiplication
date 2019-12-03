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
    (define numberRowsMatrix1 (list-ref listF 0))
    ;Get the number of columns in the first matrix
    (define numberColumnsMatrix1 (list-ref listF 1))
    ;Get index to know where to divide the lists
    (define indexList (+ 2 (* numberRowsMatrix1 numberColumnsMatrix1)))
    ;Get the number of rows in the second matrix
    (define numberRowsMatrix2 (list-ref listF indexList))
    ;Get the number of columns in the second matrix
    (define numberColumnsMatrix2 (list-ref listF (+ 1 indexList)))

     (cond 
        ;If the numer of columns from the first matrix is not the same as the 
        ;number of rows of the second matrix, the matrices can not be multiplied together 
        ;and the program ends
        [ (not (= numberColumnsMatrix1 numberRowsMatrix2)) 
          (display "The number of columns of the first matrix must be the same as the number of rows of the second matrix")] 
        
        [

          ;Split the list with all the information into the separate matrix
          (let-values (((list1 list2) (split-at listF indexList)))

          ;Get only the elements of the matrix
          (define firstMatrixElements  (cdr (cdr list1)))
          (define secondMatrixElements (cdr (cdr list2)))
          
          ;Create matrix
          (define Matrix1 (list->matrix numberRowsMatrix1 numberColumnsMatrix1 firstMatrixElements))
          (define Matrix2 (list->matrix numberRowsMatrix2 numberColumnsMatrix2 secondMatrixElements))
          
          ;Convert matrix to list of list to do the math
          (define MatrixList1 (matrix->list* Matrix1))
          (define MatrixList2 (matrix->list* Matrix2))

          ;Display the matrix and results
          (displayln "\n First matrix:\n ")
          (printMatrix  MatrixList1)
          (displayln "\nSecond matrix: \n")
          (printMatrix MatrixList2) 
          (displayln "\nMatrix Result: \n")

          ;Define the threads to multiply separately the different parts of the matices
          (define threads (map make-worker '(One Two Three Four)))
          
          (let*
            ( 
              ;Define the data to be sent to the threads
              [data (append MatrixList1 '(end end end end))]
              [n 0]  
            )
              (for-each (lambda (message) 
                (define row (append (list message) MatrixList2))
                (set! n (add1 n))
                (channel-put channel-work (list row n))) data)

            ;wait for the threads to finish
            (for-each thread-wait threads))
      )
        ])
))

;Function to nicely print the matrix
(define (printMatrix MatrixList)
  (cond 
      [(null? MatrixList) #f]            
      [else (printf "~s\n" (first MatrixList)) 
      (printMatrix (rest MatrixList))]
  )
) 

; THREAD FUNCTION
  ;Function to multiply each column of the second matrix by the row of the first matrix
(define (MultiplyMatrix row Matrix2)
    (for/list ([column (apply map list Matrix2)])
      (apply + (map * row column))))

; Create the thread to post the output
(thread 
  (lambda ()
    (let loop
      ( 
        ;create empty list to store the result
        [resultingMatrix empty]
        [n 1]
      )
      ;define channel to send the final matrix
      (define row (channel-get channel-out))

        ;if the row recieved is "End"
        (if (equal? (car row) "End")
          (
              ;if n = number of threads
              (if (equal? n length)
                (
                  ;(displayln "Out")
                  ; (displayln (indexSort (resultingMatrix)))

                  ;send through the channel the resulting matrix
                  (channel-put channel-result (list resultingMatrix))
                )
                  ;else add 1 to n                
                  (loop (list resultingMatrix) (+ n 1))
              )
          )
          ;if the row is not "End", add to the resultingMatrix
          (loop (append resultingMatrix (list row)) n)
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

            ;get message
            (case (car (car message))
                [(end) ;id the message is end
                    ;Send through the channel "End"
                    (channel-put channel-out (list "End"))]
                [else
                    ;call function to multyply matrix with the row and columns
                    (define result (MultiplyMatrix (car (car message)) (cdr (car message))))
                    ;send through the channel the result
                    (channel-put channel-out (list (cdr message) result))
                    (loop)])))))


;Sort result to correctly build the resulting matrix
(define (indexSort lst) 
  ;compare the indexes to determine the matrix's order
  (define (greater? a b)
     (<= (car (car a) ) (car (car b)))
  )
  (define orderedMatrix (sort lst greater?) )
  ;print the ordered matrix to show the user the matrix is in the correct order
  (printMatrix  orderedMatrix)
  (display "\n")
  ;call the removeIndex function to get only the reulting Matrix withput the index
  (removeIndex orderedMatrix)
)

(define (removeIndex lst )

  (for ([e (in-list lst)])
    (displayln  (car (cdr e)))
  )
)

(thread (lambda ()
   ;get the result from channel
    (define matriz (channel-get channel-result))
    (indexSort (car (car (car (car matriz)))))
))