(def args (dyn :args))
(def input-file (get args 1))
(def part (get args 2))
(def input-string 
  (with [f (file/open input-file :r)]
    (string/slice (file/read f :all) 0 -2)))
(def lines (string/split "\n" input-string))

(defn concat-nums [a b]
  (+ b (* a (math/pow 10 (+ 1 (math/floor (math/log10 (int/to-number b))))))))

(defn can-merge-to [target num & rest]
  (if (= 0 (length rest))
      (= target num)
      (do
        (def val (get rest 0))
        (or
          (can-merge-to target ; 
            (array/concat (array (+ num val)) (array/slice rest 1)))
          (can-merge-to target ; 
            (array/concat (array (* num val)) (array/slice rest 1)))
          (and 
            (= part "2")
            (can-merge-to target ; 
              (array/concat 
                (array (concat-nums num val)) (array/slice rest 1))))))))

(defn value [line]
  (do
    (def [sum-str & parts-str] (string/split ": " line))
    (def sum (int/u64 sum-str))
    (def parts (map int/u64 (string/split " " (get parts-str 0))))
    (if (can-merge-to sum ;parts) sum 0)))

(print (+ ;(map value lines)))
