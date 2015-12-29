(defmodule gtk.cellrenderertext
  (export all))

(defun new (caller)
  (lgtk:cmd caller 'Gtk_cell_renderer_text_new))


