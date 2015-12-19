(defmodule gtk.treeviewcolumn
  (export all))

(defun new (caller)
  (gtk:ssnd caller 'Gtk_tree_view_column_new))

(defun pack-start (caller tree-column renderer expand?)
  (gtk:ssnd caller
            tree-column
            'Gtk_tree_view_column_pack_start
            `(,renderer ,expand?)))

(defun set-title (caller tree-column title)
  (gtk:ssnd caller tree-column 'Gtk_tree_view_column_set_title `(,title)))

(defun add-attribute (caller tree-column renderer attr column-position)
  (gtk:ssnd caller
            tree-column
            'Gtk_tree_view_column_add_attribute
            `(,renderer ,attr ,column-position)))

(defun set-resizable (caller tree-column bool)
  (gtk:ssnd caller tree-column 'Gtk_tree_view_column_set_resizable `(,bool)))
