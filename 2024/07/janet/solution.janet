(def args (dyn :args))
(def input-file (get args 1))
(def part (get args 2))
(def input-string 
  (with [f (file/open input-file :r)]
    (string/slice (file/read f :all) 0 -2)))
(def lines (string/split "\n" input-string))
(def zero (int/u64 0))

(defn scale-mask [a]
  (math/pow 10 (+ 1 (math/floor (math/log10 (int/to-number a))))))

(defn can-merge [target nums]
  (let [last (array/peek nums)
        rest (array/slice nums 0 -2)]
    (if (= 0 (length rest))
      (= target last)
      (or
        (and 
          (= zero (% target last))
          (can-merge (/ target last) rest))
        (and
          (> target last)
          (can-merge (- target last) rest))
        (and
          (= part "2")
          (let [mask (scale-mask last)]
            (and 
              (= last (% target mask))
              (can-merge 
                (int/u64 (math/floor (int/to-number (/ target mask))))
                rest))))))))
      

(defn value [line]
  (do
    (def [sum-str & parts-str] (string/split ": " line))
    (def sum (int/u64 sum-str))
    (def parts (map int/u64 (string/split " " (get parts-str 0))))
    (if (can-merge sum parts) sum 0)))

(print (+ ;(map value lines)))
