#!/usr/bin/env lfescript
(defun main (args)
  (let* (((list f p) args)
         ((tuple 'ok bin) (file:read_file f))
         (n (length (binary:split bin #"\n" '(global trim)))))
    (io:format "Received ~p lines of input for part ~s~n" (list n p))))
