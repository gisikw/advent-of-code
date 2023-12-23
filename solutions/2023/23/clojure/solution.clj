(ns solution
  (:require [clojure.string :as str]))

(defn stacksize [] (try (throw (Exception. "")) (catch Exception e (count (.getStackTrace e)))))
(defn prss [] (print (stacksize) " "))

(defn start-pos [grid]
  [0 (str/index-of (first grid) ".")])

(defn end-pos [grid] 
  [(- (count grid) 1) (str/index-of (last grid) ".")])

(defn char-at [grid [row col]]
  (nth (grid row) col))

(defn in-bounds [grid [row col]]
  (let [size (count grid)]
    (cond
      (< row 0) false
      (< col 0) false
      (>= row size) false
      (>= col size) false
      :else true)))

(defn is-open [grid coord]
  (not= \# (char-at grid coord)))

(defn adjacent-tiles [[row col]]
  [[(+ row 1) col]
   [(- row 1) col]
   [row (+ col 1)]
   [row (- col 1)]])

(defn includes? [prev item]
  (some #{item} prev))

(defn all-neighbors [grid at prev]
  (filterv (partial is-open grid)
    (filterv (partial in-bounds grid)
      (filterv #(not (includes? prev %))
        (adjacent-tiles at)))))

(defn neighbors [grid at prev]
  (case (char-at grid at)
    \^ (filterv #(not (includes? prev %)) [[ (- 1 (first at)) (second at)]])
    \< (filterv #(not (includes? prev %)) [[ (first at) (- 1 (second at))]])
    \> (filterv #(not (includes? prev %)) [[ (first at) (+ 1 (second at))]])
    \v (filterv #(not (includes? prev %)) [[ (+ 1 (first at)) (second at)]])
    (all-neighbors grid at prev)))

(defn make-next [steps prev coord]
  [coord (+ 1 steps) prev])

(defn make-nexts [grid state]
  (let [coord (first state)
        steps (second state)
        prev (nth state 2)
        n (neighbors grid coord prev)]
    (map (partial make-next steps (conj [coord] prev)) n)))

(defn max-dist [grid dest best states]
  (if (empty? states) best
    (let [state (first states)
          coord (first state)
          steps (second state)]
      (if (= coord dest)
        (recur grid dest (max best steps) (rest states))
        (recur grid dest best (concat (make-nexts grid state) (rest states)))))))
 
(defn -main [& args]
  (let [input-file (first args)
        part (second args)
        content (slurp input-file)
        grid (str/split content #"\n")
        start (start-pos grid)
        end (end-pos grid)]
    (println (max-dist grid end 0 [[start 0 [-1 -1]]]))))
