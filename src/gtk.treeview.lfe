(defmodule gtk.treeview
  (export all))

(defun set-model (caller widget-id store)
  (gtk:ssnd caller widget-id 'Gtk_tree_view_set_model `(,store)))

(defun append (caller widget-id column)
  (gtk:ssnd caller widget-id 'Gtk_tree_view_append_column `(,column)))
