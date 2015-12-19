(defmodule gtk.rc
  (export all))

(defun parse (sender gtk-version app-name)
  (gtk:ssnd sender '() 'Gtk_rc_parse `(,(get-file gtk-version app-name))))

(defun get-file (gtk-version app-name)
  (filename:join `(,(gtk.util:get-priv-dir app-name) ,gtk-version "gtkrc")))
