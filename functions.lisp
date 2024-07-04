; macro to define instructions
; note: 
(defmacro definstruction (name args &body body)
  """Define a new instruction by pushing it onto the symbol map. 
     Implicitly increment the next-instruction register.
  """
  `(push  
    (list ',name (lambda ,args
                   (modify 'next-instruction 
                           (+ (ref 'next-instruction) 1))
                   ,@body))
    *symbol-map*))

; implication that the branch will change the next-instruction register
(defmacro defbranch (name args &body body)
  """Define a new instruction without implicitly incrementing the
  next-instruction register. The instruction is expected to increment the
  register itself. 
  """
  `(push  
    (list ',name (lambda ,args ,@body))
    *symbol-map*))

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
  (dolist (a lst)
    (if (equalp (car a) mem)
        (return (cadr a)))))

(defun ref (val)
  (afind val *symbol-map*))

(defun modify (symbol new-value)
  (map-into *symbol-map* 
            (lambda (x) 
              (if (eql (car x) symbol) 
                  (list symbol new-value)
                  x))
            *symbol-map*))
