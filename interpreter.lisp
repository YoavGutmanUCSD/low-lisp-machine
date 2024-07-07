(load "globals.lisp")
(load "functions.lisp")
(load "instruction-definitions.lisp")
(load "eval.lisp")

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

; (defun io-loop ()
;   (print *root-map*)
;   (terpri)
;   (format t "[~D]: " (ref 'next-instruction))
;   (force-output)
;   (let ((user-in (read-line)))
;     (when (string= user-in "$exit") (return-from io-loop nil))
;     (instruction-eval (string->lisp user-in)))
;   (io-loop))

"
1. begin is ended by exit
2. can't exit if not in begin
3. crash if try to leave begin state without end
"
(defun io-loop ()
  (do* 
    ((state 'NORMAL)
     (start-code-index 0 (if (eql state 'normal)
                             (1+ start-code-index)
                             start-code-index))
     (user-in))
    ((or (eql state 'EXIT) (not (member state '(NORMAL BEGIN)))) (print "exiting"))
    (when (eql state 'normal)
      (print *root-map*)
      (terpri)
      (format t "[~D]: " (ref 'next-instruction))
      (force-output))
    (let ((instruction (string->lisp (until-comment-sequence (read-line)))))
      (case (car instruction)
        ('$exit (setf state 'EXIT))
        ('$begin (setf state 'BEGIN))
        ('$end (if (eql state 'BEGIN)
                   (progn
                     (setf state 'NORMAL)
                     (format t "Running code block...~%")
                     (asm-eval (reverse *code*))
                     (format t "DONE")
                     (setf start-code-index (+ (length *code*) start-code-index))
                     (setf *code* nil))
                   (setf state 'EXIT)))
         (t (if (eql state 'NORMAL)
                (if (not (member (car instruction) *branch-names*))
                 (instruction-eval instruction)
                 (progn 
                   (setf state 'exit)
                   (format t "You can't jump outside a $begin...$end block.~%")))
                (push instruction *code*))))
      (when (eql state 'EXIT) (return-from io-loop nil)))))
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
(io-loop)
