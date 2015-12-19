(defmodule gtk.value
  (export all))

(defun set (caller key value)
  (gtk:ssnd caller key 'GN_value_set `(,value)))
