(defmodule gtk.widget
  (export all))

(defun hide (caller widget-id)
  (gtk:ssnd caller 'Gtk_widget_hide '()))

(defun show (caller widget-id)
  (gtk:ssnd caller 'Gtk_widget_show '()))

(defun freeze-child-notify (caller widget-id)
  (gtk:ssnd caller widget-id 'Gtk_widget_freeze_child_notify '()))

(defun thaw-child-notify (caller widget-id)
  (gtk:ssnd caller widget-id 'Gtk_widget_thaw_child_notify '()))

(defun set-sensitive (caller widget-id bool)
  (gtk:ssnd caller widget-id 'Gtk_widget_set_sensitive `(,bool)))
