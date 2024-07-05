(load "globals.lisp")
(load "functions.lisp")
(load "instruction-definitions.lisp")

(defvar *interpreter-commands* 
  ; these are the 5 features i want to have in the interpreter
  '($exit
    $begin
    $end
    $runfrom
    $label))

(setf *code* 
      '((sim 12)
        (mov r1)
        (sim 23)
        (mov r2)
        (sim 0)
        (add r1)
        (add r2)))
(defvar *hamming* 
  '((sim 23) 
    (mov r1) ; r1 is 23
    (sim 12) ; r0 is 12
    (xor r1) ; r0 is 12 ^ 23
    (mov r2) ; r2 is 12 ^ 23
    (sim 1)  
    (mov r3) ; r3 is 1
    (sim 0)  ; r0 is 0
    ; begin loop
    (lsh r2)
    (jz 5)
    (jc 2)
    (j -3)
    (add r3)
    (j -5)
    (jc 2)
    (j 5)
    (add r3)))

(defvar *overflow*
  '((sim 12)
    (mov r1)
    (sub r1)
    (sim 255)
    (mov r1)
    (add r1)))

  ; (map nil (lambda (x) 
  ;            (instruction-eval x)
  ;            (print *root-map*))
  ;      code) 

(defun string->lisp (string-in)
  (read-from-string (concatenate 'string "(" string-in ")")))

(defun io-loop ()
  (print *root-map*)
  (terpri)
  (format t "[~D]: " (ref 'next-instruction))
  (force-output)
  (let ((user-in (read-line)))
    (when (string= user-in "$exit") (return-from io-loop nil))
    (instruction-eval (string->lisp user-in)))
  (io-loop))

"
1. begin is ended by exit
2. can't exit if not in begin
3. crash if try to leave begin state without end
"
; decipher state
; (defun interpret-state (state curr-state)
;   (cond 
;     ((and (eql state 'BEGIN) (not (eql curr-state 'begin)))
;      'BEGIN)
;     ((and (eql state 'END) (eql curr-state 'begin))
;      'NORMAL)
;     ((and (eql state 'READFROM) (not (eql curr-state 'begin))))
;     (t 'EXIT)))

; (defun io-loop (&optional (state 'NORMAL))
;   (if (eql state 'normal) (io-preamble))
;   (format t "[~D]: " *current-instruction*)
;   (force-output)
;   (let ((user-in (read-line)))
;     (if (char= (elt user-in 0) #\$)

;         (let ((new-state (interpret-state (read-from-string user-in :start 1) state)))
;           (io-loop new-state))

;         (progn 
;           (instruction-eval (string->lisp user-in)) 
;           (io-loop)))))

; (defun io-preamble () 
;   (print *root-map*)
;   (terpri)
;   (force-output))
