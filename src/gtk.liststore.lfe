(defmodule gtk.liststore
  (export all))

(defun new (caller column-count column-types)
  (gtk:ssnd caller 'Gtk_list_store_newv `(,column-count ,column-types)))

(defun clear (caller store)
  (gtk:ssnd caller store 'Gtk_list_store_clear '()))

(defun append (caller store)
  (append caller store 'gtkTreeIter))

(defun append (caller store type)
  (gtk:ssnd caller store 'Gtk_list_store_append `(,type)))

(defun set (caller store key value)
  (set caller store 'gtkTreeIter key value))

(defun set (caller store type key value)
  (gtk:ssnd caller store 'Gtk_list_store_set_value `(,type ,value ,key)))
