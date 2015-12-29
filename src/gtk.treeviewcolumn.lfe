(defmodule gtk.treeviewcolumn
  (export all))

(defun new (caller)
  (lgtk:cmd caller 'Gtk_tree_view_column_new))

(defun pack-start (caller tree-column renderer expand?)
  (lgtk:cmd caller
            tree-column
            'Gtk_tree_view_column_pack_start
            `(,renderer ,expand?)))

(defun set-title (caller tree-column title)
  (lgtk:cmd caller tree-column 'Gtk_tree_view_column_set_title `(,title)))

(defun add-attribute (caller tree-column renderer attr column-position)
  (lgtk:cmd caller
            tree-column
            'Gtk_tree_view_column_add_attribute
            `(,renderer ,attr ,column-position)))

(defun set-resizable (caller tree-column bool)
  (lgtk:cmd caller tree-column 'Gtk_tree_view_column_set_resizable `(,bool)))
