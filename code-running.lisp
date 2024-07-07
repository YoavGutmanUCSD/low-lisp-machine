; this is basically just a big test
; not a long lived file?
(load "globals.lisp")
(load "functions.lisp")
(load "instruction-definitions.lisp")
(load "eval.lisp")

; fill memory
(dotimes (i 64)
  (setf (aref *memory* i) (random 256)))

; (defvar *problem1-code* (print (read-code-file "myasm-code/yoav-code-problem1-try2.myasm")))
; this code crashes if 
(setf *code* (read-code-file (second *posix-argv*)))
(check-if-any-instruction-bad *code*)

(asm-eval *code*)

