(defmodule top
  (export all))

(defun start ()
  (logjam:setup)
  (logjam:debug "Starting 'top' app ...")
  (case (whereis (MODULE))
    ('undefined
      (spawn #'top-gui:init/0))
    (_
      'already-started)))

(defun stop ()
  (! (MODULE) 'quit))
