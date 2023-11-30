(ns solution)

(defn -main
  [& args]
  (if (< (count args) 2)
    (println "Usage: clojure -M -m solution <input-file> <part>")
    (let [input-file (first args)
          part (second args)
          content (slurp input-file)
          lines (count (clojure.string/split content #"\n"))]
      (println (str "Received " lines " lines of input for part " part)))))
