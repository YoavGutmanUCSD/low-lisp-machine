(load "globals.lisp")
(load "functions.lisp")
(load "eval.lisp")

(defun make-enum (symbols &optional (starting-num 0))
  (mapcar #'list
          symbols
          (loop for i from starting-num to (length symbols) collect i)))
(defvar *opcodes* 
  (cons '(sim 1)
        (make-enum '(add xor lsh mov load store jc jz j lj))))
(defvar *register-map* 
  (make-enum '(r0 r1 r2 r3 r4 r5 r6 r7)))
; 
(defun byte->binary-string (int dim) 
  (assert (< int (expt 2 dim)))
  (let ((int-written (write-to-string int :base 2)))
    ; thanks stackoverflow
    (format nil 
            "~A~A"
            (format nil "~v@{~A~:*~}" 
                    (- dim (length int-written)) 
                    #\0)
            int-written)))

(defun convert-instruction (inst)
  (cond 
    ; sim special case
    ((eql (car inst) 'sim)
     (+ (ash (second (assoc 'sim *opcodes*)) 8)
        (cadr inst)))
    ; jump instructions have immediates
    ((member (car inst) '(j jc jz))
     (+ (ash (second (assoc (car inst) *opcodes*)) 4)
        (cadr inst)))
    ; all other instructions have registers
    (t (+ (ash (second (assoc (car inst) *opcodes*)) 4)
          (second (assoc (cadr inst) *register-map*))))))

(defun code->string (code)
  (string-trim '(#\Newline)
   (reduce (lambda (a x) 
             (concatenate 'string a 
                          (byte->binary-string (convert-instruction x) 9)
                          '(#\Newline)))
           code
           :initial-value "")))

(defun main ()
  (let ((code (read-code-file (second *posix-argv*))))
    (with-open-file (outfile (or (third *posix-argv*) 
                                 "a.out")
                             :direction :output
                             :if-exists :supersede)
      (princ (code->string code) outfile))))

(main)
