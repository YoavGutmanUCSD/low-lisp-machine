(defun asm-eval (code)
  (do 
    ((index (ref 'next-instruction) (ref 'next-instruction)))
    ((>= index (length code)) t)
    (instruction-eval (nth index code)) 
    (format t "Instruction ~D:" index)
    (print (nth index code))
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

(defun check-if-any-instruction-bad (code)
  (format t "checking...~%" )
  (dolist (i code)
    (if (assoc (car i) *symbol-map*) 
        t
        (print i))))

(defun string->lisp (string-in)
  (read-from-string (concatenate 'string "(" string-in ")")))

(defun until-comment-sequence (line) 
  (subseq line 0 
          (dotimes (i (1- (length line)))
            (when (string= (subseq line i (+ i 2)) "//") (return i)))))

(defun read-code-file (filename)
  (with-open-file (file filename :direction :input :if-does-not-exist nil)
    (do* 
      ((code nil)
       (line (read-line file nil 'eof) (read-line file nil 'eof))
       (i 0 (1+ i)))
      ((eql line 'eof) (reverse code))
      (force-output)
      (unless (or (string= line "") (string= (subseq line 0 2) "//"))
        (let ((code-line 
                (string->lisp (until-comment-sequence line))))
          (if code-line 
              (push code-line code)))))))

