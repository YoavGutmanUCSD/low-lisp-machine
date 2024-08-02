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
    (modify x (mod (+ result (ref 'c)) 256))
    (modify 'c c)
    (modify 'z z)))

(definstruction rsh (x)
  (multiple-value-bind (result c z)
    (rsh8 (ref x))
    (modify x (mod (+ result (ash (ref 'c) 7)) 256))
    (modify 'c c)
    (modify 'z z)))

(definstruction not (x) 
  (modify x (mod (lognot (ref x)) 256)))

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
(defbranch jnc (x) 
  (increment-next-instruction (if (/= (ref 'c) 1) x 1))
  (modify 'c 0))

(defbranch jz (x) 
  (increment-next-instruction (if (= (ref 'z) 1) x 1))
  (modify 'z 0))

(defbranch j (x) 
  (increment-next-instruction x))

(defbranch lj (x) 
  (increment-next-instruction (ref x)))

(defbranch mark (counter)
  (increment-next-instruction 1)
  (clear-counter counter))

(defbranch back (counter)
  (increment-next-instruction (- 0 (counter counter)))
  (clear-counter counter))

(definstruction done ()
  (modify 'done-flag 1))

(definterpreterfn $break (name) 
  (and
    *can-break*
   (unless (y-or-n-p "Breakpoint [~A] encountered. Continue?~%" (string-upcase name))
     (modify 'done-flag 1))))

(definterpreterfn $disable-break ()
  (setf *can-break* nil))

(definterpreterfn $define (name val)
  (push (list name val)
        *constants*))

(definterpreterfn $label (name)
  (push name *labels*))

(defpreprocessfn jnc (x)
  (cond
    ((numberp x)
     `(jnc ,x))
    ((assoc x *labels*)
     
     )
    ((assoc x *constants*)
     `(jnc ,(cadr (assoc x *constants*))))
    (t (error "Bad argument to jnc"))

    ))

(definterpreterfn $begin ())

(definterpreterfn $end ())
