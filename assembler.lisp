(load "globals.lisp")
(load "functions.lisp")
(load "eval.lisp")
(require :asdf)

(defun make-enum (symbols &optional (starting-num 0))
  (mapcar #'list
          symbols
          (loop for i from starting-num to (length symbols) collect i)))
(defvar *opcodes* 
  (cons '(sim 1)
        (make-enum '(load store mov add sub not xor lsh rsh done jnc jz lj mark back) 1)))
(defvar *register-map*
  (make-enum '(r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14 r15)))
; 
(defun byte->binary-string (int dim) 
  (assert (< int (expt 2 dim)))
  (let ((int-written (write-to-string int :base 2)))
    ; thanks stackoverflow
    ; https://stackoverflow.com/questions/24754552/repeat-string-character-with-format
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
    ((member (car inst) '(jnc jz j mark back))
     (+ (ash (second (assoc (car inst) *opcodes*)) 4)
        (cadr inst)))
    ; done special case
    ((eql (car inst) 'done)
     (ash (second (assoc 'done *opcodes*)) 4))
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
  (let* ((command-line-args (uiop:command-line-arguments))
         (code (read-code-file (first command-line-args)))
         (fname (second command-line-args)))
    (with-open-file (outfile (or fname 
                                 "a.out")
                             :direction :output
                             :if-exists :supersede)
      (princ (code->string code) outfile))))

(main)
