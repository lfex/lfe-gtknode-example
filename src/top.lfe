(defmodule top
  (export all))

(defun start ()
  (logjam:setup)
  (logjam:debug "Starting '~p' app ..." `(,(MODULE)))
  (case (whereis (MODULE))
    ('undefined
      (spawn #'top-gui:init/0))
    (_
      'already-started)))

(defun stop ()
  (! (MODULE) 'quit))
