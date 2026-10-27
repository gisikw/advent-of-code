(let [[f p] arg n (accumulate [n 0 _ (io.lines f)] (+ n 1))]
  (print (.. "Received " n " lines of input for part " p)))
