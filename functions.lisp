(load "globals.lisp")
(defmacro definstruction (name args &body body)
  `(progn 
    (defun ,name ,args 
      ,@(search-and-replace *symbol-map* body))
    (push symbol-map '(,name (function ,name)))))

(defun search-and-replace (symbol-map code)
  (mapcar
    (lambda (x)
      (if (listp x)
          (search-and-replace symbol-map x)
          (or (afind x symbol-map) x)))
    code))

; there should be something like this already in the stdlib
; required: list of length 2
(defun afind (mem lst)
  (dolist (a lst)
    (if (equalp (car a) mem) 
        (return (cadr a)))))
