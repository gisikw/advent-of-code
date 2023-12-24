(ns solution
  (:require [clojure.string :as str]))

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

(defn all-neighbors [grid at prev]
  (filterv (partial is-open grid)
    (filterv (partial in-bounds grid)
      (filterv #(not= prev %)
        (adjacent-tiles at)))))

(defn neighbors [part grid [row col] prev]
  (if (= part "2") (all-neighbors grid [row col] prev)
    (case (char-at grid [row col])
      \^ (filterv #(not= prev %) [[(- row 1) col]])
      \< (filterv #(not= prev %) [[row (- col 1)]])
      \> (filterv #(not= prev %) [[row (+ col 1)]])
      \v (filterv #(not= prev %) [[(+ row 1) col]])
      (all-neighbors grid [row col] prev))))

(defn find-next-node [grid neighbors-fn graph steps [prevRow prevCol] [row col]]
  (if (contains? graph [row col]) [[row col] steps]
   (let [n (neighbors-fn grid [row col] [prevRow prevCol])]
     (cond 
       (empty? n) nil
       (> (count n) 1) [[row col] steps]
       :else (recur grid neighbors-fn graph (+ 1 steps) [row col] (first n))))))

(defn build-graph [grid neighbors-fn graph [node & remaining]]
  (if (not node) graph
    (let [next-nodes (mapv (partial find-next-node grid neighbors-fn graph 1 node) (neighbors-fn grid node [-1 -1]))
          valid-nodes (filterv some? next-nodes)
          graph (assoc graph node (into (sorted-map) valid-nodes))
          unprocessed (remove #(contains? graph %) (map first valid-nodes))]
      (recur grid neighbors-fn graph (concat remaining unprocessed)))))

(defn make-sub [graph parent steps visited node]
  [node (+ steps ((graph parent) node)) visited])

(defn subtraversals [graph [node steps visited]] ; -> [[node steps visited]]
  (let [nexts (remove #(some #{%} visited) (keys (graph node)))]
    (map (partial make-sub graph node steps (conj visited node)) nexts)))

(defn traverse [graph dest best [state & remaining]]
  (if (not state) best
    (let [[node steps visited] state]
      (if (= node dest)
        (recur graph dest (max best steps) remaining)
        (recur graph dest best (concat (subtraversals graph state) remaining))))))
 
(defn -main [& args]
  (let [input-file (first args)
        part (second args)
        neighbors-fn (partial neighbors part)
        content (slurp input-file)
        grid (str/split content #"\n")
        start (start-pos grid)
        end (end-pos grid)
        graph (build-graph grid neighbors-fn { end {} } [start])
        ]
    (println (traverse graph end 0 [[start 0 []]]))))
