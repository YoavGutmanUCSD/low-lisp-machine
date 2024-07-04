(load "globals.lisp")
(load "functions.lisp")
(load "instruction-definitions.lisp")

; (setf *code* 
;       '((sim 12)
;         (mov r1)
;         (sim 23)
;         (mov r2)
;         (sim 0)
;         (add r1)
;         (add r2)))

(defun asm-eval (code)
  (map nil (lambda (x) 
             (instruction-eval x)
             (print *root-map*))
       code))

(defun instruction-eval (instruction)
  (apply (ref (car instruction)) (cdr instruction)))

(defun string->lisp (string-in)
  (read-from-string (concatenate 'string "(" string-in ")")))

(defun io-loop ()
  (print *root-map*)
  (terpri)
  (format t "[~D]: " *current-instruction*)
  (force-output)
  (let ((user-in (read-line)))
    (when (string= user-in "$exit") (return-from io-loop nil))
    (instruction-eval (string->lisp user-in)))
  (io-loop))


(io-loop)
