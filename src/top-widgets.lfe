(defmodule top-widgets
  (export all))

(include-file "include/top.lfe")

(defun treeview-init (caller app-state)
  (let ((columns (make-columns)))
    (add-columns caller columns)
    (let ((list-store (gtk.liststore:new caller
                                         (length columns)
                                         (get-types columns))))
      (gtk.treeview:set-model caller 'treeview1 list-store)
      ;; XXX update app state and return it
      (set-app-treeview
        app-state
        (make-treeview columns columns store list-store)))))

(defun treeview-column
  (((match-column title title attr attr data-col data-col))
    ))

(defun make-columns ()
  (list
    (make-column title "Process"
                 attr "text"
                 data-col 0
                 type 'string)
    (make-column title "Size"
                 attr "text"
                 data-col 1
                 type 'integer)
    (make-column title "Message Queue"
                 attr "text"
                 data-col 2
                 type 'integer)
    (make-column title "Reduction Count"
                 attr "text"
                 data-col 3
                 type 'integer)))

(defun add-columns (caller columns)
  (lists:foreach
    (lambda (column)
      (top_widgets:treeview_column caller column))
    columns))

(defun get-types (columns)
  (lists:map
    (lambda (column)
      (column-type column))
    columns))
