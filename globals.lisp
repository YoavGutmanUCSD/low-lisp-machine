; rom
(defvar *code* nil)

; branch instruction names go here 
(defvar *branch-names* nil)

(defvar *symbol-map* '(
  ; registers
  (r0 nil)
  (r1 nil)
  (r2 nil)
  (r3 nil)
  (r4 nil)
  (r5 nil)
  (r6 nil)
  (r7 nil)
  (r8 nil)
  (r9 nil)
  (r10 nil)
  (r11 nil)
  (r12 nil)
  (r13 nil)
  (r14 nil)
  (r15 nil)
  ; pcntr
  (next-instruction 0)
  ; flags
  (z 0)
  (c 0)
  (done-flag 0)))

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
(defvar *interpreter-commands* '())
(defvar *constants* '())
(defvar *labels* '())
(defvar *interpreter-state* 'NORMAL)
(defvar *can-break* t)
(defvar *preprocess-fns* '())
