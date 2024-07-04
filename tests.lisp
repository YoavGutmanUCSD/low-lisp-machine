(load "functions.lisp")
(load "globals.lisp")
(load "instruction-definitions.lisp")
(defvar tests nil)
(defmacro deftest (name &body body)
  `(push (lambda () 
           (format t "Running test ~A~%" ',name)
           ,@body) tests))





(deftest test-instruction-output
  (let ((fn (afind 'add *symbol-map*)))
    (apply fn '(r1 r2)))
  (format t "r0 is ~A~%" (ref 'r0)))

(deftest test-symbol-replacement 
  (print (search-and-replace *symbol-map* '(r0 r1 a b c z)))
  (terpri))

(deftest test-afind
  (let ((fn (afind 'add *symbol-map*)))
    (print fn)
    (terpri)))

(deftest test-symbol-contents
  (print *symbol-map*)
  (terpri))

(deftest test-instruction-expand 
  (let ((expanded
          (macroexpand-1 
            '(definstruction add (x y)
              (modify r0 (+ (ref x) (ref y)))))))
    (print expanded)
    (terpri)))


(format t "Running test DEFTEST-TEST: this is how the expansion looks like:~%")
(print (macroexpand-1 
         '(deftest test-instruction-output
           (definstruction add (x y) (setf r0 (+ x y)))
           (apply (afind *symbol-map* 'add) '(1 2))
           (format t "r0 is ~A~%" (ref 'r0)))))
(terpri)

; run all tests
(map nil #'funcall tests)
