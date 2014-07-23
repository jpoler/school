(define (element ptr)
  (car (car ptr)))
(define (backward ptr)
  (cdr (car ptr)))
(define (forward ptr)
  (cdr ptr))
(define (make-link-front ele after)
  (cons (cons ele '()) after))
(define (make-link-rear ele before)
  (cons (cons ele before) '()))

(define (set-backward-ptr! ptr value)
  (set-cdr! (car ptr) value))
(define (set-forward-ptr! ptr value)
  (set-cdr! ptr value))

(define (front-ptr deque)
  (car deque))
(define (rear-ptr deque)
  (cdr deque))
(define (set-front-ptr! deque element)
  (set-car! deque element))
(define (set-rear-ptr! deque element)
  (set-cdr! deque element))
(define (empty-deque? deque)
  (or (null? (front-ptr deque))
      (null? (rear-ptr deque))))
(define (make-deque)
  (cons '() '()))


(define (front-deque deque)
  (if (empty-deque? deque)
      (error "called front deque on an empty deque " deque)
      (element (front-ptr deque))))
(define (rear-deque deque)
  (if (empty-deque? deque)
      (error "called rear-deque on an empty deque " deque)
      (element (rear-ptr deque))))

;; Think about this, but if the front and back are equal, set
;; back ptr to point to front, otherwise set old front to point to new front

;; also, may want to create a set-front-ptr! and set-rear-ptr! function
(define (front-insert-deque! deque value)
  (if (empty-deque? deque)
      (let ((new (make-link-front value '())))
	(set-front-ptr! deque new)
	(set-rear-ptr! deque new)
	value)
      (let ((new (make-link-front value (front-ptr deque))))
	(set-backward-ptr! (front-ptr deque) new)
	(set-front-ptr! deque new)
	value)))

(define (rear-insert-deque! deque value)
  (if (empty-deque? deque)
      (let ((new (make-link-front value '())))
	(set-front-ptr! deque new)
	(set-rear-ptr! deque new)
	value)
      (let ((new (make-link-rear value (rear-ptr deque))))
	(set-forward-ptr! (rear-ptr deque) new)
	(set-rear-ptr! deque new)
	value)))

(define (front-delete-deque! deque)
  (if (empty-deque? deque)
      (error "front-delete-deque called on an empty deque " deque)
      (begin
	(set-front-ptr! deque (forward (front-ptr deque)))
	(if (not (null? (front-ptr deque)))
	    (set-backward-ptr! (front-ptr deque) '())))))

(define (rear-delete-deque! deque)
  (if (empty-deque? deque)
      (error "rear-delete-deque called on an empty deque " deque)
      (begin
	(set-rear-ptr! deque (backward (rear-ptr deque)))
	(if (not (null? (rear-ptr deque)))
	    (set-forward-ptr! (rear-ptr deque) '())))))

		
(define d (make-deque))

(front-insert-deque! d '1)
(front-insert-deque! d '2)
(front-insert-deque! d '3)
(rear-insert-deque! d '0)


(front-deque d)
(rear-deque d)

(front-delete-deque! d)
(rear-delete-deque! d)
