(load "globals.lisp")
(defmacro definstruction (name args &body body)
  `(progn 
    (defun ,name ,args 
      ,@(search-and-replace *symbol-map* body))
    (push symbol-map '(,name (function ,name)))))


; tests
(Defun run-test-1 () 
  (let ((expanded
          (macroexpand-1 
            '(definstruction add (x y) 
              (setf r0 (+ x y))))))
    (print expanded)))
(defun run-test-2 ()
  (print (search-and-replace *symbol-map* '(r0 r1 a b c z))))

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

(run-test-1)
(run-test-2)
