(defmodule gtk.treeview
  (export all))

(defun set-model (caller widget-id store)
  (lgtk:cmd caller widget-id 'Gtk_tree_view_set_model `(,store)))

(defun append (caller widget-id column)
  (lgtk:cmd caller widget-id 'Gtk_tree_view_append_column `(,column)))
