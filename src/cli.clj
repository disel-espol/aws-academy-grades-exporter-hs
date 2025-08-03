(ns cli
  (:require [clojure.tools.cli :refer [parse-opts]])
  (:gen-class))

(def cli-options 
  [["-f" "--file FILE" "The from which to read grades"
    :missing "Missing the file name"]
   ["-o" "--out OUTPUT" "Where to store the result of processing"
    :default :postgres
    :default-desc "Store grades to a PostgreSQL database"]])

(defn main [& args]
  (let [{:keys [options errors]} (parse-opts args cli-options)]
    options))

(main "-f hola")
