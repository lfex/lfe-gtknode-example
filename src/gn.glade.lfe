(defmodule gn.glade
  (export all))

(defun init (sender gtk-version app-name)
  (gtk:cmd sender
           '()
           'GN_glade_init
           `(,(get-file gtk-version app-name))))

(defun get-file (gtk-version app-name)
  (++ (filename:join `(,(gtk.util:get-priv-dir app-name)
                       ,gtk-version
                       ,(atom_to_list app-name)))
      ".glade"))
