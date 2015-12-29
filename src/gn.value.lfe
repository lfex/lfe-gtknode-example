(defmodule gn.value
  (export all))

(defun set (caller key value)
  (lgtk:cmd caller 'GN_value_set `(,key ,value)))

(defun get (caller key)
  (lgtk:cmd caller 'GN_value_get `(,key)))

(defun unset (caller key)
  (lgtk:cmd caller 'GN_value_unset `(key)))
