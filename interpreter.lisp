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
      (princ "values: ")
      (princ *root-map*)
      (terpri)
      (princ "counters: ")
      (princ *counter-map*)
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

(dotimes (i 64)
  (setf (aref *memory* i) (random 255)))
(io-loop)
