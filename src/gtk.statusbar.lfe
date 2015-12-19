(defmodule gtk.statusbar
  (export all))

(defun get-context-id (caller sb-id)
  (gtk:ssnd caller sb-id 'Gtk_statusbar_get_context_id '("state")))

(defun push (caller sb-id context-id msg)
  (gtk:ssnd caller sb-id 'Gtk_statusbar_push `(,context-id ,msg)))

(defun pop (caller sb-id context-id)
  (gtk:ssnd caller sb-id 'Gtk_statusbar_pop `(,context-id)))
