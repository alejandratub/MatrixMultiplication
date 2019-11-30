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

(define (read_file)
  ;(display "Enter the name of the file you will like to use as input (matrix.txt): ")
  ;(define file (read))
  (let
    ;Read from file and convert to list
    ([listF (file->list "matriz.txt")])
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
        (displayln  MatrixList1)
        (displayln "Second matrix: ")
        (displayln MatrixList2) 
        (displayln "Matrix Result: ")

        ; (for/list ([r Matrix1])
        ;   ; (MultiplyMatrix r MatrixList2))
        ;   (displayln MatrixList2))
        (define MatrixLists (list MatrixList1 MatrixList2))
        
        ; (displayln MatrixLists)

        ; (for/list ([r MatrixLists])
        ;       (displayln (car r)))
        ; (displayln (cdr MatrixLists))

        (define threads (map make-worker '(One Two)))
        (let*
          ( 
            ; [data (append MatrixList1 MatrixList2)])
            [data (append MatrixList1 '(end end))])
          ; Show the list
          ; (displayln (car data)))
          ; Send each number to be processed
          ; (for-each (lambda (message) (channel-put channel-work [message MatrixList2])) data))
          ; (for-each (lambda (message) (append (list message) MatrixList2)) data)
          (for-each (lambda (message) 
            (define row (append (list message) MatrixList2))
            (channel-put channel-work row )) data)
            ; (displayln row)
          ; (for-each (lambda (message) (channel-put channel-work message ) data))
          ; (lambda (MatrixList2) (channel-put channel-work MatrixList2))
          ; (for-each (lambda (message) (displayln message)) data)
          ; Wait for the threads to finish
          (for-each thread-wait threads))

        ;Call the multiplication function
        ; SEND THE ROWS TO THE CHANNEL
        ; (MultiplyMatrix (car MatrixList1) MatrixList2)
        ; (MultiplyMatrix (cdr MatrixList1) MatrixList2)
        ; (MultiplyMatrix firstM secondM)
    )
  )
)


; THREAD FUNCTION
(define (MultiplyMatrix row Matrix2)
    (for/list ([c (apply map list Matrix2)])
      (apply + (map * row c))))

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
            ; (channel-put channel-out (format "Thread ~a: n = ~a" name message))
            ; (display message)))))
            ; (for/list ([r message])
            ;   (displayln r))))))
            ; (displayln (car message))))))
            ; (display (cdr message))))))
            ; (for/list ([r message])
              ; (display r))))))
            ; (displayln message)))))
            (case (car message)
                [(end)
                    (channel-put channel-out (format "Thread ~a finishing" name))]
                [else
                    (define result (MultiplyMatrix (car message) (cdr message)))
                    ; (displayln result)
                    (channel-put channel-out (format "Thread ~a: n = ~a | result = ~a" name message result))
                    (loop)])))))