(load "functions.lisp")
(load "globals.lisp")
(load "instruction-definitions.lisp")
(load "eval.lisp")

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
  (print *root-map*)
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
  (print *root-map*)
  (terpri))

(deftest test-read-code-hamming 
  (let ((code-correct
          '((sim 23) 
            (mov r1) ; r1 is 23
            (sim 12) ; r0 is 12
            (xor r1) ; r0 is 12 ^ 23
            (mov r2) ; r2 is 12 ^ 23
            (sim 1)  
            (mov r3) ; r3 is 1
            (sim 0)  ; r0 is 0
            ; begin loop
            (lsh r2)
            (jz 5)
            (jc 2)
            (j -3)
            (add r3)
            (j -5)
            (jc 2)
            (j 5)
            (add r3))))
    (if (equalp code-correct (read-code-file "myasm-code/hamming.myasm"))
      (format t "Code is properly read from files.~%")
      (format t "Code is improperly read from files!~%"))))


(format t "[LOG]Running meta test DEFTEST-TEST: this is how the expansion looks like:~%")
(print (macroexpand-1 
         '(deftest test-instruction-output
           (definstruction add (x y) (setf r0 (+ x y)))
           (apply (afind *symbol-map* 'add) '(1 2))
           (format t "r0 is ~A~%" (ref 'r0)))))
(terpri)

; run all tests
(map nil #'funcall (reverse tests))
