(defmodule gtk.util
  (export all))

(defun get-priv-dir (app-name)
  (case (code:priv_dir app-name)
    (#(error bad_name)
      "priv")
    (priv-dir
      priv-dir)))

