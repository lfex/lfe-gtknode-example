(defmodule gtk.value
  (export all))

(defun set (caller key value)
  (gtk:cmd caller 'GN_value_set `(,key ,value)))

(defun get (caller key)
  (gtk:cmd caller 'GN_value_get `(,key)))

(defun unset (caller key)
  (gtk:cmd caller 'GN_value_unset `(key)))
