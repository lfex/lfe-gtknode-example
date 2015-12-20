(defmodule gtk
  (export all))

(defun start (name)
  (logjam:info `#(c ,(logjam:caller)) "Starting GTK ~p ..." `(,name))
  (gtknode:start name))

(defun stop (name)
  (logjam:info `#(c ,(logjam:caller)) "Stopping GTK ~p ..." `(,name))
  (gtknode:stop name))

(defun ssnd (sender command)
  (snd sender command '()))

(defun ssnd (sender command args)
  (snd sender command args))

(defun ssnd
  ((sender '() command args)
    (snd sender command args))
  ((sender widget command args)
    (snd sender command (cons widget args))))

(defun snd (sender command args)
  ; (logjam:debug `#(c ,(logjam:caller))
  ;               "Sending to '~p' the command ~p with args ~p ..."
  ;               `(,sender ,command ,args))
  (! sender `#(,(self) (#(,command ,args))))
  (receive
    (`#(,sender #(reply (#(ok ,rep))))
      (case rep
        ('void
          rep)
        (_
          ;;(logjam:debug `#(c ,(logjam:caller)) "Got response: ~p" `(,rep))
          rep)))
    (`#(,sender #(reply (#(error ,rep))))
      (logjam:error `#(c ,(logjam:caller)) "Got error: ~p" `(,rep))
      (erlang:error `#(,command ,args ,rep)))))
