 ;(define lst (list 5 6 3 4 2 1))
          ;  (define (sort-by-car-number [lst (list 5 6 3 4 2 1)] ) 
          ;(sort lst >= #:key car))

;(define (function)
;(define list (list ())))


(define (sort-by-car-number lst) 
 (define (object-greater? a b)
    (<= (car (car a) ) (car (car b))))
  (sort lst object-greater?))