; rom
(defvar *code* nil)

(defvar *symbol-map* '(
  ; registers
  (r0 0)
  (r1 0)
  (r2 0)
  (r3 0)
  (r4 0)
  (r5 0)
  (r6 0)
  (r7 0)
  ; pcntr
  (next-instruction 0)
  ; flags
  (z 0)
  (c 0)))

; will only hold registers, next instruction,and flags 
(defvar *root-map* *symbol-map*)

; used for interpreter
(defvar *current-instruction* 0)
