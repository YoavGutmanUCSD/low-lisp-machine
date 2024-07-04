(load "globals.lisp")
(load "functions.lisp")

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
             (apply (ref (car x)) (cdr x))
             (print *root-map*))
       code))

(defun io-loop ()
  (print *root-map*)
  (terpri)
  (format t "[~D]: " *current-instruction*)
  (let (())
    
    ))
