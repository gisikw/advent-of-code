(defun count-lines (filename)
  (with-open-file (stream filename)
    (loop for line = (read-line stream nil)
          while line
          count line)))

(defun main ()
  (let ((input-file (second *posix-argv*))
        (part (third *posix-argv*)))
    (format t "Received ~a lines of input for part ~a~%"
            (count-lines input-file)
            part)))

(main)
