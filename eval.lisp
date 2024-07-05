(defun asm-eval (code)
  (do 
    ((index (ref 'next-instruction) (ref 'next-instruction)))
    ((>= index (length code)) t)
    (instruction-eval (nth index code)) 
    (format t "Instruction ~D:" index)
    (print *root-map*)
    (terpri)))

(defun instruction-eval (instruction)
  (apply (ref (car instruction)) (cdr instruction)))

(defun clear ()
  """Set all registers to 0."""
  (map-into *root-map*
            (lambda (x) 
              (list (car x) 0))
            *root-map*))
