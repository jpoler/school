(define (fib2 n)
  (fib-iter 1 0 0 1 n))
(define (fib-iter a b p q count)
  (cond ((= count 0) b)
        ((even? count)
         (fib-iter a
                   b
                   (t2 q p 1 1)
		   (t1 q p 1 1)
                   (/ count 2)))
        (else (fib-iter (+ (* b q) (* a q) (* a p))
                        (+ (* b p) (* a q))
                        p
                        q
                        (- count 1)))))

(fib-iter 1 0 0 1 16)
(t1 1 0 1 2)
(t2 1 0 1 2)

(t1 1 1 1 2)
(t2 1 1 1 2)

(t1 3 2 2 3)
(t2 3 2 2 3)
(t1 5 3 1 1)
(t2 5 3 1 1)
(


(fib-iter 1 0 0 1 8)
(p-squared 1 0 0 1)
(q-squared 1 0 0 1)
(p-squared 1 0 2 3)
(q-squared 1 0 2 3)
(p-squared 1 0 34 55)

(define t2
  (lambda (a b p q)
    (+ (* b p) (* a q))))

(define t1
  (lambda (a b p q)
    (+ (* b q) (* a q) (* a p))))

(define (fib1 n)
  (cond ((= n 0) 0)
        ((= n 1) 1)
        (else (+ (fib1 (- n 1))
                 (fib1 (- n 2))))))

(define p-squared
  (lambda (a b p q)
    (t2 (t1 a b p q) (t2 a b p q) (t2 a b p q) (t1 a b p q))))

(define q-squared
  (lambda (a b p q)
    (t1 (t1 a b p q) (t2 a b p q) (t2 a b p q) (t1 a b p q))))



(fib1 40000)
(fib2 40000)


