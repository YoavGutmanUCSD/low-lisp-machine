(load "functions.lisp")
(defvar tests nil)
(defmacro deftest (name &body body)
  `(push (lambda () 
           (format t "Running test ~A~%" ',name)
           ,@body) tests))


(deftest test-instruction-expand 
  (let ((expanded
          (macroexpand-1 
            '(definstruction add (x y) 
              (setf r0 (+ x y))))))
    (print expanded)
    (terpri)))

(deftest test-symbol-replacement 
  (print (search-and-replace *symbol-map* '(r0 r1 a b c z)))
  (terpri))

; run all tests
(map nil #'funcall tests)
