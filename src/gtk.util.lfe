(defmodule gtk.util
  (export all))

(defun get-priv-dir (app-name)
  (case (code:priv_dir app-name)
    (#(error bad_name)
      "priv")
    (priv-dir
      priv-dir)))

(defun atom->int (atom)
  (list_to_integer
    (atom_to_list atom)))
