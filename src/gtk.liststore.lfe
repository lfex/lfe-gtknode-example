(defmodule gtk.liststore
  (export all))

(defun new (caller column-count column-types)
  (lgtk:cmd caller 'Gtk_list_store_newv `(,column-count ,column-types)))

(defun clear (caller store)
  (lgtk:cmd caller store 'Gtk_list_store_clear '()))

(defun append (caller store)
  (append caller store 'gtkTreeIter))

(defun append (caller store type)
  (lgtk:cmd caller store 'Gtk_list_store_append `(,type)))

(defun set (caller store key value)
  (set caller store 'gtkTreeIter key value))

(defun set (caller store type key value)
  (lgtk:cmd caller store 'Gtk_list_store_set_value `(,type ,value ,key)))
