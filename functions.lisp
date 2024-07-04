(load "globals.lisp")

; macro to define instructions
(defmacro definstruction (name args &body body)
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
