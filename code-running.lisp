(load "globals.lisp")
(load "functions.lisp")
(load "instruction-definitions.lisp")
(load "eval.lisp")

(defvar *hamming* 
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
    (add r3)))

(defvar *hamming-long* 
  ; i -> r6
  ; j -> r7
  '((sim 0)
    (mov r6)
    (sim 1)
    (mov r7)
    ; increment 
    ()
    ()
    ()
    ()
    ()
    ))

(defvar *arbitrary-memory-operation* 
  '((sim 0)
    (mov r6)
    (sim 1)
    (mov r7)
    (load r6)
    (load r7)))

; fill memory
(dotimes (i 64)
  (setf (aref *memory* i) (random 256)))

(asm-eval *arbitrary-memory-operation*)

