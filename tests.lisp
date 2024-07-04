(load "functions.lisp")
(load "globals.lisp")
(load "instruction-definitions.lisp")
(load "interpreter.lisp")

(defvar tests nil)
(defmacro deftest (name &body body)
  `(push (lambda () 
           (format t "[LOG]Running test ~A~%" ',name)
           ,@body) tests))


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

(deftest test-run-code 
  (format t "before:~%")
  (print *symbol-map*)
  (terpri)
  (let ((test-code  
          '((sim 12)
            (mov r1)
            (sim 23)
            (mov r2)
            (sim 0)
            (add r1)
            (add r2))))
    (asm-eval test-code))
  (format t "after:~%")
  (print *symbol-map*)
  (terpri))


(format t "[LOG]Running test DEFTEST-TEST: this is how the expansion looks like:~%")
(print (macroexpand-1 
         '(deftest test-instruction-output
           (definstruction add (x y) (setf r0 (+ x y)))
           (apply (afind *symbol-map* 'add) '(1 2))
           (format t "r0 is ~A~%" (ref 'r0)))))
(terpri)

; run all tests
(map nil #'funcall tests)
