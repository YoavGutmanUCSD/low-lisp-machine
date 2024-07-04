(definstruction add (x)
  (modify 'r0 (+ (ref 'r0) (ref x))))

(definstruction sub (x y)
  (modify 'r0 (- (ref 'r0) (ref x))))

(definstruction mov (destination)
  (modify destination (ref 'r0)))

(definstruction sim (value)
  (modify 'r0 value))

(definstruction xor (x) 
  (modify 'r0 (logxor (ref 'r0) (ref x))))

(defbranch jc (x) 
  (modify 'next-instruction (+ (ref 'next-instruction)
                               (if (= (ref 'c) 0) x 1) )))

(defbranch jz (x) 
  (modify 'next-instruction (+ (ref 'next-instruction)
                               (if (= (ref 'z) 0) x 1) )))

(defbranch j (x) 
  (modify 'next-instruction (+ (ref 'next-instruction) 1)))
