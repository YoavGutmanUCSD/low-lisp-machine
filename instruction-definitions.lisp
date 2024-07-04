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
(defvar *counter* 0)

; old 
; (definstruction add (x)
;   (modify 'r0 (+ (ref 'r0) (ref x))))

; (definstruction sub (x y)
;   (modify 'r0 (- (ref 'r0) (ref x))))

(definstruction mov (destination)
  (modify destination (ref 'r0)))

(definstruction sim (value)
  (modify 'r0 value))

(definstruction xor (x) 
  (modify 'r0 (logxor (ref 'r0) (ref x))))

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
