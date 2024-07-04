(load "globals.lisp")
(load "functions.lisp")

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

(definstruction xor (x) 
  (modify 'r0 (logxor (ref 'r0) (ref x))))

(definstruction jc (x) 
  (when (= (ref 'c) 0) 
    (modify 'next-instruction x)))

(definstruction jz (x) 
  (when (= (ref 'z) 0) 
    (modify 'next-instruction x)))
