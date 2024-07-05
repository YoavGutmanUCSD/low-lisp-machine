; arithmetic 
(definstruction add (x)
  (multiple-value-bind (result c z)
    (add8 (ref 'r0) (ref x))
    (modify 'r0 result)
    (modify 'c c)
    (modify 'z z)))

(definstruction sub (x)
  (multiple-value-bind (result c z)
    (sub8 (ref 'r0) (ref x))
    (modify 'r0 result)
    (modify 'c c)
    (modify 'z z)))

(definstruction xor (x) 
  (modify 'r0 (logxor (ref 'r0) (ref x))))

; in-place arithmetic
(definstruction lsh (x)
  (multiple-value-bind (result c z)
    (lsh8 (ref x))
    (modify x result)
    (modify 'c c)
    (modify 'z z)))

(definstruction rsh (x)
  (multiple-value-bind (result c z)
    (rsh8 (ref x))
    (modify x result)
    (modify 'c c)
    (modify 'z z)))

; inter-register operations 
(definstruction mov (destination)
  (modify destination (ref 'r0)))

(definstruction sim (value)
  (modify 'r0 value))


; memory instructions load/store
(definstruction load (x) 
  (modify 'r0 (aref *memory* (ref x))))

(definstruction store (x) 
  (setf (aref *memory* (ref x)) (ref 'r0)))

; branches
(defbranch jc (x) 
  (modify 'next-instruction (+ (ref 'next-instruction)
                               (if (= (ref 'c) 1) x 1)))
  (modify 'c 0))

(defbranch jz (x) 
  (modify 'next-instruction (+ (ref 'next-instruction)
                               (if (= (ref 'z) 1) x 1)))
  (modify 'z 0))

(defbranch j (x) 
  (modify 'next-instruction (+ (ref 'next-instruction) x)))
