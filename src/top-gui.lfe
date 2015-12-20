(defmodule top-gui
  (export all))

(include-file "include/top.lfe")

(defun init ()
  ;; start the c-node and it's port handler
  (gtk:start (MODULE))
  (gtk.rc:parse (MODULE) (GTK-VERSION) 'top)
  ;; load the glade file into the c-node
  (gtk.glade:init (MODULE) (GTK-VERSION) 'top)
  (loop (init-gui)))

(defun init-gui ()
  (top-widgets:init-treeview (MODULE)
                             (state-init (make-app))))

(defun state-init (state)
  (let ((id (gtk.statusbar:get-context-id (MODULE) 'statusbar1)))
    (gtk.statusbar:push (MODULE) 'statusbar1 id "Connected")
    (state-disconnect (set-app-statusbar-ctx state id))))

(defun loop (state)
  (receive
    (`#(,(MODULE) #(signal #(window1 ,_)))
      (quit state))
    (`#(,(MODULE) #(signal #(quit1 ,_)))
      (quit state))
    (`#(,(MODULE) #(signal #(connect ,_)))
      (loop (connect state)))
    (`#(,(MODULE) #(signal #(disconnect ,_)))
      (loop (disconnect state)))
    (`#(,(MODULE) #(signal #(about1 ,_)))
      (loop (show-about state)))
    (`#(,(MODULE) #(signal #(dialogb ,_)))
      (loop (hide-about state)))
    (`#(,(MODULE) #(signal #(dialog1 ,_)))
      (loop (hide-about state)))
    (`#(data ,data)
      (loop (update state data)))
    ('quit
      (quit state))
    (unexpected
      (log:warning `#(c ,(logjam:caller)) "Got unexpected msg: ~p" `(,unexpected)))))

(defun quit (state)
  (logjam:debug `#(c ,(logjam:caller)) "Shutting down ...")
  (disconnect state)
  (gtk:stop (MODULE))
  (logjam:debug `#(c ,(logjam:caller)) "Exiting ..."))

(defun connect (state)
  (logjam:debug `#(c ,(logjam:caller)) "Connecting ...")
  (do-connect)
  (state-connect state))

(defun disconnect (state)
  (logjam:debug `#(c ,(logjam:caller)) "Disconnecting ...")
  (do-disconnect)
  (state-disconnect state))

(defun hide-about (state)
  (gtk.widget:hide (MODULE) 'dialog1))

(defun show-about (state)
  (gtk.widget:show (MODULE) 'dialog1))

(defun update (state data)
  (gtk.widget:freeze-child-notify (MODULE) 'treeview1)
  (clear (app-treeview state))
  (populate (app-treeview state) data)
  (gtk.widget:thaw-child-notify (MODULE) 'treeview1)
  state)

(defun state-connect
  (((= (match-app statusbar-ctx sb-ctx) state))
    (gtk.statusbar:pop (MODULE) 'statusbar1 sb-ctx)
    (toggle-statusbar 'false)
    state))

(defun state-disconnect
  (((= (match-app statusbar-ctx sb-ctx) state))
    (gtk.statusbar:push (MODULE) 'statusbar1 sb-ctx "Disconnected")
    (toggle-statusbar 'true)
    state))

(defun toggle-statusbar (conn)
  (gtk.widget:set-sensitive (MODULE) 'connect conn)
  (gtk.widget:set-sensitive (MODULE) 'disconnect (not conn)))

(defun do-connect ()
  (top-data:assert (self)))

(defun do-disconnect ()
  (top-data:stop))

(defun clear
  (((match-treeview store store))
    (gtk.liststore:clear (MODULE) store)))

(defun populate
  ((_ '())
    'ok)
  (((= (match-treeview store store columns cols) treeview) (cons row data))
    (gtk.liststore:append (MODULE) store)
    (populate-list-row store cols row)
    (populate treeview data)))

(defun populate-list-row
  ((_ '() '())
    'ok)
  ((store (cons col cols) (cons row data))
    (gtk.value:set (MODULE) 'gval row)
    (gtk.liststore:set (MODULE) store 'gval (column-data-col col))
    (populate-list-row store cols data)))
