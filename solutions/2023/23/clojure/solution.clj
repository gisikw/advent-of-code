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
      (filterv #(not= prev %)
        (adjacent-tiles at)))))

(defn neighbors [grid at prev]
  (case (char-at grid at)
    ; \^ (filterv #(not (includes? prev %)) [[ (- 1 (first at)) (second at)]])
    ; \< (filterv #(not (includes? prev %)) [[ (first at) (- 1 (second at))]])
    ; \> (filterv #(not (includes? prev %)) [[ (first at) (+ 1 (second at))]])
    ; \v (filterv #(not (includes? prev %)) [[ (+ 1 (first at)) (second at)]])
    (all-neighbors grid at prev)))

(defn make-next [steps prev coord]
  [coord (+ 1 steps) prev])

(defn make-nexts [grid state]
  (let [coord (first state)
        steps (second state)
        prev (nth state 2)
        n (neighbors grid coord prev)
        ;_ (println "At " coord " with prev " prev)
        nextPrev (conj prev coord)]
        ; nextPrev (conj (if (> (count n) 1) prev (pop prev)) coord)]
    (map (partial make-next steps nextPrev) n)))

(defn max-dist [grid dest best states]
  (if (empty? states) best
    (let [state (first states)
          coord (first state)
          steps (second state)]
      (if (= coord dest)
        (let [_ (println "Found " steps " (" best ")" )]
          (recur grid dest (max best steps) (rest states)))
        (recur grid dest best (concat (make-nexts grid state) (rest states)))))))

(defn find-next-node [grid graph steps [prevRow prevCol] [row col]]
  (if (contains? graph [row col]) [[row col] steps]
   (let [n (neighbors grid [row col] [prevRow prevCol])]
    (if (> (count n) 1) [[row col] steps]
     (recur grid graph (+ 1 steps) [row col] (first n))))))

(defn build-graph [grid graph [node & remaining]]
  (if (not node) graph
    (let [;_ (println "evalling " node)
          next-nodes (mapv (partial find-next-node grid graph 1 node) (neighbors grid node [-1 -1]))
          graph (assoc graph node (into (sorted-map) next-nodes))
          unprocessed (remove #(contains? graph %) (map first next-nodes))
          ;_ (println "Unprocessed: " unprocessed)
          ]
      (recur grid graph (concat remaining unprocessed)))))

(defn make-sub [graph parent steps visited node]
  [node (+ steps ((graph parent) node)) visited])

(defn subtraversals [graph [node steps visited]] ; -> [[node steps visited]]
  (let [nexts (remove #(includes? visited %) (keys (graph node)))]
    (map (partial make-sub graph node steps (conj visited node)) nexts)))

(defn traverse [graph dest best [state & remaining]]
  (if (not state) best
    (let [[node steps visited] state]
      (if (= node dest)
        (let [
              ;_ (println "Reached dest in " steps " steps")
            ]
          (recur graph dest (max best steps) remaining))
        (recur graph dest best (concat (subtraversals graph state) remaining))))))
 
(defn -main [& args]
  (let [input-file (first args)
        part (second args)
        content (slurp input-file)
        grid (str/split content #"\n")
        start (start-pos grid)
        end (end-pos grid)
        graph (build-graph grid { end {} } [start])
        ]
    (println (traverse graph end 0 [[start 0 []]]))
    ))
