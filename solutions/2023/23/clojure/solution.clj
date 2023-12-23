(ns solution
  (:require [clojure.string :as str]))

(defn stacksize [] (try (throw (Exception. "")) (catch Exception e (count (.getStackTrace e)))))
(defn prss [] (print (stacksize) " "))

(defn start-pos [grid] 
  (list 0 (str/index-of (first grid) ".")))

(defn end-pos [grid] 
  (list (- (count grid) 1) (str/index-of (last grid) ".")))

(defn char-at [grid coord]
  (nth (nth grid (first coord)) (second coord)))

(defn in-bounds [grid coord]
  (let 
    [row (first coord)
     col (second coord)
     size (count grid)]
    (cond
      (< row 0) false
      (< col 0) false
      (>= row size) false
      (>= col size) false
      :else true)))

(defn is-open [grid coord]
  (not= \# (char-at grid coord)))

(defn adjacent-tiles [coord]
  (let
    [row (first coord)
     col (second coord)]
    (list 
      (list (+ row 1) col)
      (list (- row 1) col)
      (list row (+ col 1))
      (list row (- col 1)))))

(defn all-neighbors [grid at from]
  (filter (partial is-open grid)
    (filter (partial in-bounds grid)
      (filter #(not= % from) 
        (adjacent-tiles at)))))

(defn neighbors [grid at prev]
  (case (char-at grid at)
    \^ (filter #(not= % prev) (list (list (- 1 (first at)) (second at))))
    \< (filter #(not= % prev) (list (list (first at) (- 1 (second at)))))
    \> (filter #(not= % prev) (list (list (first at) (+ 1 (second at)))))
    \v (filter #(not= % prev) (list (list (+ 1 (first at)) (second at))))
    (all-neighbors grid at prev)))

(defn make-next [steps prev coord]
  (list coord (+ 1 steps) prev))

(defn make-nexts [grid state]
  (let [coord (first state)
        steps (second state)
        prev (nth state 2)
        n (neighbors grid coord prev)]
    (map (partial make-next steps coord) n)))

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
    (println (max-dist grid end 0 (list (list start 0 '((-1 -1))))))))
