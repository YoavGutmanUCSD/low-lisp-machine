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

  ; (map nil (lambda (x) 
  ;            (instruction-eval x)
  ;            (print *root-map*))
  ;      code) 

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
