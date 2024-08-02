; this is basically just a big test
; not a long lived file?
(load "globals.lisp")
(load "functions.lisp")
(load "instruction-definitions.lisp")
(load "eval.lisp")

(defun run-code-in-file (file &optional (should-print t) ) 
  ; fill memory
  ; (dotimes (i 64)
  ;   ; (setf (aref *memory* i) (random 256)))
  ;   (setf (aref *memory* i) i)) 

  ; run code
  (let* ((code (read-code-file file))
         (invalid (and code (find-invalid code))))
    (if (and code
             (null invalid)
             (asm-eval code :should-print should-print))
        (progn 
          (format t "Done.")
          0)
        (progn 
          (format t "File has invalid instructions or is empty.~%")
          404)))
  ; this code crashes if you don't use SBCL
  ; (if (cdr *posix-argv*)
  ;     (progn
  ;       (setf *code* (read-code-file (second *posix-argv*)))
  ;       (check-if-any-instruction-bad *code*)
  ;       (asm-eval *code*) )
  ;     (format t "Add a file argument.~%"))
  ; return success 0
  )
(defun read-memory-file (filename)
  (with-open-file (file filename :direction :input :if-does-not-exist nil)
    (do* 
      ((code nil)
       (line (read-line file nil 'eof) (read-line file nil 'eof))
       (i 0 (1+ i)))
      ((eql line 'eof) (reverse code))
      (push (read-from-string (concatenate 'string "#b" line)) code))))
(let ((mem
        (read-memory-file "test0.txt")))
  (dotimes (i (length mem))
    (setf (aref *memory* i) (nth i mem))))

(run-code-in-file (second *posix-argv*) (not (string= (third *posix-argv*) "noprint")))
