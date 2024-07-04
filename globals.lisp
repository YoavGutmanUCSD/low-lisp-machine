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

(defun modify (symbol new-value)
  (map-into *symbol-map* 
            (lambda (x) 
              (if (eql (car x) symbol) 
                  (list symbol new-value)
                  x))
            *symbol-map*))
