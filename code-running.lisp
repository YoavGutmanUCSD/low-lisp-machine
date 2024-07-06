; this is basically just a big test
; not a long lived file?
(load "globals.lisp")
(load "functions.lisp")
(load "instruction-definitions.lisp")
(load "eval.lisp")

; fill memory
(dotimes (i 64)
  (setf (aref *memory* i) (random 256)))

(defvar *problem1-code* (print (read-code-file "myasm-code/yoav-code-problem1-try2.myasm")))
(check-if-any-instruction-bad *problem1-code*)

(asm-eval *problem1-code*)

