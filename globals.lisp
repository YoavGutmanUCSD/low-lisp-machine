; registers
(defvar *R0* 0)
(defvar *R1* 0)
(defvar *R2* 0)
(defvar *R3* 0)
(defvar *R4* 0)
(defvar *R5* 0)
(defvar *R6* 0)
(defvar *R7* 0)

; flags
(defvar *z* 0)
(defvar *c* 0)

; pcntr and rom
(defvar *next-instruction* 0)
(defvar *code* nil)

; instruction map
(defvar *instructions* nil)

(defvar *symbol-map* '(
  (r0 *r0*)
  (r1 *r1*)
  (r2 *r2*)
  (r3 *r3*)
  (r4 *r4*)
  (r5 *r5*)
  (r6 *r6*)
  (r7 *r7*)
  (next-instruction *next-instruction*)
  (z *z*)
  (c *c*)))

