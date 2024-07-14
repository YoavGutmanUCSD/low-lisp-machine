; this is basically just a big test
; not a long lived file?
(load "globals.lisp")
(load "functions.lisp")
(load "instruction-definitions.lisp")
(load "eval.lisp")

(defun main () 
  ; fill memory
  (dotimes (i 64)
    (setf (aref *memory* i) (random 256)))

  ; this code crashes if you don't use SBCL
  (if (cdr *posix-argv*)
      (progn
        (setf *code* (read-code-file (second *posix-argv*)))
        (check-if-any-instruction-bad *code*)
        (asm-eval *code*) )
      (format t "Add a file argument.~%"))
  ; return success 0
  0)
