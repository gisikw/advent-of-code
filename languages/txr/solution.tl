(let ((f [*args* 0]) (p [*args* 1]))
  (put-line `Received @(len (file-get-lines f)) lines of input for part @p`))
