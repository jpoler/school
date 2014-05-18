###2.54###
PROMPT:
------------------------------------------------------------
Exercise 2.54.  Two lists are said to be equal? if they contain equal elements arranged in the same order. For example,

(equal? '(this is a list) '(this is a list))

is true, but

(equal? '(this is a list) '(this (is a) list))

is false. To be more precise, we can define equal? recursively in terms of the basic eq? equality of symbols by saying that a and b are equal? if they are both symbols and the symbols are eq?, or if they are both lists such that (car a) is equal? to (car b) and (cdr a) is equal? to (cdr b). Using this idea, implement equal? as a procedure
------------------------------------------------------------

(define (my-equal? a b)
  (cond ((and (null? a) (null? b)) true)
	((and (list? (car a)) (list? (car b))) (my-equal? (car a) (car b)))
	((and (number? (car a)) (number? (car b)) (= (car a) (car b))) (my-equal? (cdr a) (cdr b)))
	((and (symbol? (car a)) (symbol? (car b)) (eq? (car a) (car b))) (my-equal? (cdr a) (cdr b)))
	(else false)))

(my-equal? '(1 2 '(a b)) '(1 2 '(a b)))
;Value: #t

(my-equal? '(1 2 '(a b)) '(1 2 '(a c)))
;Value: #f





