(def args (dyn :args))
(def input-file (get args 1))
(def input-string 
  (with [f (file/open input-file :r)]
    (string/slice (file/read f :all) 0 -2)))
(def lines-count (length (string/split "\n" input-string)))
(def part (get args 2))
(print "Received " lines-count " lines of input for part " part)))
