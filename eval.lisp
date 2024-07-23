(defvar *line-numbers* nil)
(defun asm-eval (code &key (how-many nil how-many-p))
  (do 
    ((index (ref 'next-instruction) (ref 'next-instruction))
     (instrs-run 0 (1+ instrs-run)))
    ((or (>= index (length code)) (ref 'done)) t)
    (instruction-eval (nth index code))
    (print-info index (nth index code))
    (when (how-many-p)
      (setf instrs-run 0)
      (or (y-or-n-p "~D instructions run. Continue?~%" how-many)
          (return t)))))

; (defmacro asm-eval (code &key (how-many nil how-many-p))
;   `(do 
;     ((index (ref 'next-instruction) (ref 'next-instruction))
;      (code ,code)
;      (instrs-run 0 (1+ instrs-run)))
;     ((>= index ,(length code)) t)
;     (instruction-eval (nth index code))
;     (print-info index (nth index code))
;     ,(when how-many-p 
;       `(when (= instrs-run ,how-many)
;          (setf instrs-run 0)
;          (or (y-or-n-p "~D instructions run. Continue?~%" ,how-many)
;              (return t))))))

(defun print-info (instruction-num current-instruction)
    (format t "Instruction ~D:" instruction-num)
    (print current-instruction)
    (terpri)
    (princ "values: ")
    (princ *root-map*)
    (terpri)
    (princ "counters: ")
    (princ *counter-map*)
    (terpri))

(defun instruction-eval (instruction)
  (apply (ref (car instruction)) (cdr instruction)))

(defun clear ()
  """Set all registers to 0."""
  (map-into *root-map*
            (lambda (x) 
              (list (car x) 0))
            *root-map*))

(defun find-invalid (code)
  (reduce 
    (lambda (a x)
      (if (assoc (car x) *symbol-map*)
          a
          (cons x a)))
    code
    :initial-value '()))

(defun clear-root-map ()
  (map-into *root-map*
            (lambda (x) (list (car x) 0))
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
      (unless (or (string= line "") (string= (subseq line 0 2) "//"))
        (let ((code-line 
                (string->lisp (until-comment-sequence line))))
          (if code-line 
              (push code-line code)))))))
