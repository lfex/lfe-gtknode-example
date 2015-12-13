;;;; This module is a port of some utility functions tjat were originally in the
;;;; Erlang module top_top.erl, written by Mats Cronqvist from the examples for his
;;;; Erlang GTK+ library project, gtknode.
;;;;
(defmodule top-util
  (export (sort 4)
          (->str 1)))

(defun sort (key rows data old-data)
  (lists:sublist
    (lists:sort (lambda (a b) (cmp key a b))
                (diff key data old-data))
    rows))

(defun cmp
  (('reds `(,_ ,a ,_ ,x1) `(,_ ,b ,_ ,x2)) (when (== x1 x2))
    (< b a))
  (('reds `(,_ ,_ ,_ ,x) `(,_ ,_ ,_ ,y))
    (< y x)))

(defun diff
  (('reds data old-data)
    (top-data:get-reductions data old-data '())))

(defun ->str (term)
  (lists:flatten
    (io_lib:format "~p" `(,term))))
