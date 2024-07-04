(load "globals.lisp")
(load "functions.lisp")
; just arithmetic and not in place for now

(definstruction add (x)
  (modify 'r0 (+ (ref 'r0) (ref x))))

(definstruction sub (x y)
  (modify 'r0 (- (ref 'r0) (ref x))))

(definstruction j (x) 
  (modify 'next-instruction x))

(definstruction mov (destination)
  (modify destination (ref 'r0)))

(definstruction sim (value)
  (modify 'r0 value))
