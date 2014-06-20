(define (first-term terms)
  (apply-generic 'first-term terms))
(define (rest-terms terms)
  (apply-generic 'rest-terms terms))
(define (empty-termlist? terms)
  (apply-generic 'empty-termlist? terms))
(define (the-empty-termlist type)
  ((get 'the-empty-termlist type)))
(define (make-term order coeff) (list order coeff))
(define (order term) (car term))
(define (coeff term) (cadr term))
(define (adjoin-term term terms)
  ((get 'adjoin-term (type-tag terms)) term (contents terms)))
(define (max-order terms)
  (apply-generic 'max-order terms))
(define (cardinality terms)
  (apply-generic 'cardinality terms))
(define (dense-repr terms)
  (apply-generic 'dense-repr terms))
(define (sparse-repr terms)
  (apply-generic 'sparse-repr terms))
(define (pad-zeros high low)
  (make-list (- high low) 0))
(define (find-vars poly)
  (apply-generic 'find-vars poly))
(define (poly? x)
  (and (pair? x) (eq? (type-tag x) 'polynomial)))
(define (remove-duplicate-vars vars)
  (define (dup-iter seq result)
    (cond ((null? seq) result)
	  ((member (car seq) result) (dup-iter (cdr seq) result))
	  (else (dup-iter (cdr seq) (append result (list (car seq)))))))
  (dup-iter vars '()))
(define (order-vars vars)
  (sort vars (lambda (x y)
	       (let ((x-length (length (memq x (variable-hierarchy))))
		     (y-length (length (memq y (variable-hierarchy)))))
		 (> x-length y-length)))))
(define (get-ordered-variables poly)
  (order-vars (remove-duplicate-vars (find-vars poly))))


(define (variable-hierarchy)
  (list 'w 'z 'y 'x))


(define (make-poly var terms)
  ((get 'make 'polynomial) var terms))


(define (install-polynomial-package)
  (define (expand-term term)
    (define (expand-term-iter lower-terms built-terms)
      (if (empty-termlist? lower-terms)
	  built-terms
	  (let ((first-lower (first-term lower-terms)))
	    (expand-term-iter (rest-terms lower-terms)
			      (adjoin-term (make-term (order term) first-lower)
					   built-terms)))))
    (if (not (poly? (coeff term)))
	term
	(let ((lower-terms (term-list (coeff term))))
	  (expand-term-iter lower-terms (the-empty-termlist 'sparse)))))

;;; DEFINITELY CHECK THIS PREVIOUS ALGORITHM BEFORE MOVING AHEAD TOO FAR

  (define (expand-termlist terms)
    (if (empty-termlist? terms)
	(the-empty-termlist (type-tag terms))
	(cons (expand (coeff (first-term terms)))
	      (expand-termlist (rest-terms terms)))))
  (define (expand-result terms)
    (if (empty-termlist? terms)
	(the-empty-termlist (type-tag terms))
	(
  
  (define (expand p)
    (if (not (poly? p))
	p
	(let ((terms (term-list p)))
	  (let ((result (expand-termlist terms)))
	    (make-poly (variable p)
		       
	    
	     
  (define (find-v p)
    (append (list (variable p)) (find-vars (term-list p))))
  (define (poly-zero? p)
    (define (zero-iter terms)
      (if (empty-termlist? terms)
	  true
	  (let ((first (first-term terms)))
	    (if (=zero? (coeff first))
		(zero-iter (rest-terms terms))
		false))))
    (zero-iter (term-list p)))

  (define (dense-poly? terms)
    (if (<= (max-order terms) (* (cardinality terms) 1.5))
	true
	false))
  (define (choose-repr terms)
    (if (dense-poly? terms)
	(dense-repr terms)
	(sparse-repr terms)))
  (define (add-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
	(let ((added-terms (add-terms (term-list p1)
				      (term-list p2))))
	  (make-poly (variable p1) (choose-repr added-terms)))
	(error "Polys not in same var -- ADD-POLY"
	       (list p1 p2))))
  (define (mul-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
	(let ((multiplied-terms (mul-terms (term-list p1)
					   (term-list p2))))
	  (make-poly (variable p1) (choose-repr multiplied-terms)))
	(error "Polys not in same var -- MUL-POLY"
	       (list p1 p2))))
  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
	  ((empty-termlist? L2) L1)
	  (else
	   (let ((t1 (first-term L1)) (t2 (first-term L2)))
	     (cond ((> (order t1) (order t2))
		    (adjoin-term
		     t1 (add-terms (rest-terms L1) L2)))
		   ((< (order t1) (order t2))
		    (adjoin-term
		     t2 (add-terms L1 (rest-terms L2))))
		   (else
		    (adjoin-term
		     (make-term (order t1)
				(add (coeff t1) (coeff t2)))
		     (add-terms (rest-terms L1)
				(rest-terms L2)))))))))
  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
	(the-empty-termlist 'sparse)
	(add-terms (mul-term-by-all-terms (first-term L1) L2)
		   (mul-terms (rest-terms L1) L2))))
  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
	(the-empty-termlist 'sparse)
	(let ((t2 (first-term L)))
	  (adjoin-term
	   (make-term (+ (order t1) (order t2))
		      (mul (coeff t1) (coeff t2)))
	   (mul-term-by-all-terms t1 (rest-terms L))))))
  (define (div-poly p1 p2)
    (define (same-var? seq)
      (reduce-right (lambda (x y)
		      (if (false? y)
			  false
			  (eq? x y)))
		  false
		  seq))
    (let ((variables (map variable (list p1 p2))))
      (if (not (same-var? variables))
	  (error "variables are not of the same type -- DIV-POLY " variables)
	  (let ((term-lists (map term-list (list p1 p2))))
	    (let ((div-result (apply div-terms term-lists)))
	      (list (make-poly (car variables) (choose-repr (car div-result)))
		    (make-poly (car variables) (choose-repr (cadr div-result)))))))))
  (define (div-terms L1 L2)
    (define (update-dividend L1 L2 new-term)
      (add-terms L1
		 (negate
		  (mul-term-by-all-terms new-term L2))))
					
    (if (empty-termlist? L1)
	(list (the-empty-termlist 'sparse) (the-empty-termlist 'sparse))
	(let ((t1 (first-term L1))
	      (t2 (first-term L2)))
	  (if (> (order T2) (order T1))
	      (list (the-empty-termlist 'sparse) L1)
	      (let ((new-c (div (coeff t1) (coeff t2)))
		    (new-o (- (order t1) (order t2))))
		(let ((new-term (make-term new-o new-c)))
		  (let ((rest-of-result (div-terms (update-dividend L1 L2 new-term)
						   L2)))
		    (list (add-terms (adjoin-term new-term (the-empty-termlist 'sparse))
				     (car rest-of-result))
			  (cadr rest-of-result)))))))))
		  
		  
  (define (make-poly var terms) (cons var terms))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))
  (define (tag p) (attach-tag 'polynomial p))

  ;; interface to system


  (put 'add '(polynomial polynomial) (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2)
	 (tag (add-poly p1
			(make-poly (variable p2)
				   (negate (term-list p2)))))))
  (put 'mul '(polynomial polynomial) (lambda (p1 p2)
				       (tag (mul-poly p1 p2))))
  (put 'div '(polynomial polynomial) (lambda (p1 p2)
				       (let ((result (div-poly p1 p2)))
					 (list (tag (car result)) (tag (cadr result))))))
  (put 'make 'polynomial (lambda (var terms) (tag (make-poly var terms))))
  (put 'negate '(polynomial)
       (lambda (p) (tag (make-poly (variable p) (negate (term-list p))))))
  (put 'zero '(polynomial) (lambda (p) (poly-zero? p)))
  (put 'sparse-repr '(polynomial) (lambda (p) (sparse-repr (term-list p))))
  (put 'dense-repr '(polynomial) (lambda (p) (dense-repr (term-list p))))
  (put 'find-vars '(polynomial) (lambda (p) (find-v p)))
  'done)

(define (install-sparse-package)
  ;; Operations on sparse term-lists
  (define (find-v terms)
      (if (empty-termlist? terms)
	  (the-empty-termlist)
	  (let ((first (first-term terms)))	  
	    (cond ((poly? (coeff first)) (append (find-vars (coeff first)) (find-v (rest-terms terms))))
		  (else (find-v (rest-terms terms)))))))	  

  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
	term-list
	(cons term term-list)))
  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (length-termlist terms) (length terms))
  (define (empty-termlist? term-list) (null? term-list))
  (define (sparse-repr terms)
    terms)

  (define (dense-repr terms)
    (define (dense-iter terms prev-order)
      (cond ((and (empty-termlist? terms) (= prev-order 0))
	     (the-empty-termlist))
	    ((and (empty-termlist? terms) (> prev-order 0))
	     (cons 0 (dense-iter terms (- prev-order 1))))
	    (else
	     (let ((current-term (first-term terms))
		   (current-order (order (first-term terms))))
	       (cond ((= (- prev-order 1) current-order)
		      (cons (coeff current-term)
			    (dense-iter (rest-terms terms)
					(order current-term))))
		     (else
		      (cons 0 (dense-iter terms (- prev-order 1)))))))))
    (dense-iter terms (+ (max-order terms) 1)))

  (define (max-order terms)
    (if (empty-termlist? terms)
	0
	(order (first-term terms))))
  (define (cardinality terms) (length-termlist terms))
  (define (neg terms)
    (map (lambda (term)
	   (make-term (order term)
		      (negate (coeff term))))
	 terms))
  (define (tag terms) (attach-tag 'sparse terms))
  ;;; Interface to outside


  (put 'the-empty-termlist 'sparse (lambda () (tag (the-empty-termlist))))
  (put 'empty-termlist? '(sparse) (lambda (terms) (empty-termlist? terms)))
  (put 'first-term '(sparse) (lambda (terms) (first-term terms)))
  (put 'rest-terms '(sparse) (lambda (terms) (tag (rest-terms terms))))
  (put 'sparse-repr '(sparse) (lambda (terms)
				(tag (sparse-repr terms))))
  (put 'dense-repr '(sparse) (lambda (terms)
				 (attach-tag 'dense (dense-repr terms))))

  (put 'adjoin-term 'sparse (lambda (term terms) (tag (adjoin-term term terms))))
  (put 'cardinality '(sparse) (lambda (terms) (cardinality terms)))
  (put 'max-order '(sparse) (lambda (terms) (max-order terms)))
  (put 'negate '(sparse) (lambda (p) (tag (neg p))))
  (put 'find-vars '(sparse) (lambda (terms) (find-v terms)))
  'done)

(define (install-dense-package)
  (define (find-v terms)
      (if (empty-termlist? terms)
	  (the-empty-termlist)
	  (let ((first (first-term terms)))	  
	    (cond ((poly? (coeff first)) (append (find-vars (coeff first)) (find-v (rest-terms terms))))
		  (else (find-v (rest-terms terms)))))))

  (define (zero-term? term) (= 0 (coeff term)))
  (define (max-order terms) (- (length terms) 1))
  (define (cardinality terms)
    (length (filter (lambda (x) (not (= x 0))) terms)))
  (define (the-empty-termlist) '())
  (define (empty-termlist? terms) (null? terms))
  (define (first-term terms)
    (make-term (max-order terms) (car terms)))
  (define (add-term t1 t2)
    (make-term (order t1) (+ (coeff t1) (coeff t2))))
  (define (rest-terms terms) (cdr terms))
  (define (dense-repr terms)
    terms)
  (define (order-index terms order)
    (- (max-order terms) order))
  (define (get-term-by-order terms order)
    (make-term order (list-ref terms (order-index terms order))))
  (define (adjoin-term term terms)
    (define (gen-append-list term terms max-order term-order)
      (if (> term-order max-order)
	  (extend-termlist term terms max-order term-order)
	  (insert-termlist term terms max-order term-order)))
    (define (extend-termlist t tl mo to)
      (append (list (coeff t))
	      (make-list (- to (+ mo 1)) 0)
	      tl))
    (define (insert-termlist t tl mo to)
      (append (list-head tl (- mo to))
	      (list (coeff (add-term (get-term-by-order tl to)
				     t)))
	      (list-tail tl (+ 1 (order-index tl to)))))
    (cond ((and (empty-termlist? terms) (= (order term) 0))
	   (list (coeff term)))
	  (else (gen-append-list term
				 terms
				 (max-order terms)
				 (order term)))))
  (define (sparse-repr terms)
    (cond ((empty-termlist? terms) (the-empty-termlist))
	  ((zero-term? (first-term terms)) (sparse-repr (rest-terms terms)))
	  (else (cons (first-term terms) (sparse-repr (rest-terms terms))))))
  (define (neg terms)
    (map (lambda (x) (negate x)) terms))
  (define (tag terms)
    (attach-tag 'dense terms))

  ;;; Interface to outside

  (put 'the-empty-termlist 'dense (lambda () (tag (the-empty-termlist))))
  (put 'empty-termlist? '(dense) (lambda (terms) (empty-termlist? terms)))
  (put 'first-term '(dense) (lambda (terms) (first-term terms)))
  (put 'rest-terms '(dense) (lambda (terms) (tag (rest-terms terms))))
  (put 'sparse-repr '(dense) (lambda (terms) (attach-tag 'sparse (sparse-repr terms))))
  (put 'dense-repr '(dense) (lambda (terms) (tag (dense-repr terms))))
  (put 'adjoin-term 'dense (lambda (term terms) (tag (adjoin-term term terms))))
  (put 'cardinality '(dense) (lambda (terms) (cardinality terms)))
  (put 'max-order '(dense) (lambda (terms) (max-order terms)))
  (put 'negate '(dense) (lambda (terms) (tag (neg terms))))
  (put 'find-vars '(dense) (lambda (terms) (find-v terms)))
  'done)

(define (install-packages)
  (install-scheme-number-package)
  (install-rational-package)
  (install-real-package)
  (install-complex-package)
  (install-rectangular-package)
  (install-polar-package)
  (install-polynomial-package)
  (install-dense-package)
  (install-sparse-package))

(begin
  (install-packages)
  (get-ordered-variables my-first-poly))

(define my-first-poly (make-poly 'x
				 (list 'sparse
				       (list 3 (make-poly 'y (list 'sparse
								   (list 2 (make-poly 'z (list 'sparse
											       (list 4 2))))
								   (list 1 (make-poly 'z (list 'sparse
											       (list 2 1))))))))))

my-first-poly

(add my-first-poly my-first-poly)
		      




