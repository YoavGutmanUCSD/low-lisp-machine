; macro to define instructions
; note: 
(defmacro definstruction (name args &body body)
  """Define a new instruction by pushing it onto the symbol map. 
     Implicitly increment the next-instruction register.
  """
  `(push  
    (list ',name (lambda ,args
                   (increment-next-instruction 1)
                   ,@body))
    *symbol-map*))

; implication that the branch will change the next-instruction register
(defmacro defbranch (name args &body body)
  """Define a new instruction without implicitly incrementing the
  next-instruction register. The instruction is expected to increment the
  register itself. 
  """
  `(progn
    (push ',name *branch-names*)
    (push  
      (list ',name (lambda ,args ,@body))
      *symbol-map*)))

; unused -- perform beta substitution over entire input code
(defun search-and-replace (symbol-map code)
  (mapcar
    (lambda (x)
      (if (listp x)
          (search-and-replace symbol-map x)
          (or (afind x symbol-map) x)))
    code))



; functions to deal with symbol map 
(defun afind (mem lst)
  """equivalent to (cadr (assoc mem lst))"""
  (dolist (a lst)
    (if (equalp (car a) mem)
        (return (cadr a)))))

(defun ref (val &optional (lst *symbol-map*))
  (afind val lst))

;; todo: perform an operation on new-value such that it will set the flags
;; appropriately. but only when toggled
(defun modify (symbol new-value &optional (lst *symbol-map*))
  (let ((new-value (mod new-value 256))))
  (map-into lst 
            (lambda (x) 
              (if (eql (car x) symbol) 
                  (list symbol new-value)
                  x))
            lst))

; ref for counters
(defun counter (cntr)
  (afind cntr *counter-map*))

(defun clear-counter (cntr-num)
  (modify cntr-num 0 *counter-map*))

(defun increment-next-instruction (extent)
  (modify 'next-instruction (+ (ref 'next-instruction) extent))
  (map-into *counter-map* 
            (lambda (x) 
              (list (car x) (+ extent (cadr x))))
            *counter-map*))
  

; return format:
; result
; c
; z
(defun sub8 (x y)
  (values
    (mod (- x y) 256)
    (if (> y x) 1 0)
    (if (= y x) 1 0)))

(defun add8 (x y)
  (let ((result (mod (+ x y) 256)))
    (values 
      result
      (if (> (+ x y) 255) 1 0)
      (if (= result 0) 1 0))))

(defun lsh8 (x)
  (let ((result (logand (ash x 1) 255)))
    (values 
      result
      (if (> x 127) 1 0)
      (if (= result 0) 1 0))))

(defun rsh8 (x)
  (let ((result (logand (ash x -1) 255)))
    (values 
      result
      (mod x 2) ; carry bit represents the bit that "fell off" for now
      (if (= result 0) 1 0))))
