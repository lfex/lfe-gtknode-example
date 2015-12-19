(defmodule top
  (export (start 0)
          (stop 0)))

(defun start ()
  (logjam:setup)
  (logjam:debug "Starting 'top' app ...")
  (case (whereis (MODULE))
    ('undefined
      (spawn #'top_gui:init/0))
    (_
      'already-started)))

(defun stop ()
  (! (MODULE) 'quit))
