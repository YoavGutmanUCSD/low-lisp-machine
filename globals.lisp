; rom
(defvar *code* nil)

; branch instruction names go here 
(defvar *branch-names* nil)

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
  (r8 0)
  (r9 0)
  (r10 0)
  (r11 0)
  (r12 0)
  (r13 0)
  (r14 0)
  (r15 0)
  ; pcntr
  (next-instruction 0)
  ; flags
  (z 0)
  (c 0)
  (done nil)))

(defvar *counter-map* 
  (loop for i from 0 to 15 collect (list i 0)))

; will only hold registers, next instruction,and flags 
(defvar *root-map* *symbol-map*)

; memory
(defvar *memory*
  (make-array '(256)
              :initial-element 0
              :element-type '(mod 256)))

; may be used for interpreter
(defvar *current-instruction* 0)
