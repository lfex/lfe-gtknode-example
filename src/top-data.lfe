;;;; This module is a port of the Erlang module top_top.erl originally written by
;;;; Mats Cronqvist in the examples for his Erlang GTK+ library project, gtknode.
;;;;
(defmodule top-data
  (export (assert 1)
          (stop 0)
          (get-reductions 3)))

(defrecord state
  ref
  client
  (old-data '())
  (rows  100)
  (tick 2000)
  (key 'reds)
  (tags '(reg mem msgq reds)))

(defun assert (client-pid)
  (case (whereis (MODULE))
    ('undefined
      (! (spawn_link #'init/0) `#(start ,client-pid)))
    (pid
      (! pid `#(start ,client-pid)))))

(defun stop ()
  (! (MODULE) 'stop))

(defun init ()
  (register (MODULE) (self))
  (loop (make-state ref (timr (make-state)))))

(defun loop (state)
  (receive
    (`#(timeout ,_ref ,(tuple))
      (loop (send-data (set-state-ref state (timr state)))))
    (`#(start ,new-client)
      (loop (set-state state client new-client ref (timr state))))
    (stop
      (loop (set-state-ref state (untimr state))))))

(defun timr (state)
  (case (state-ref state)
    (old-ref (when (is_reference old-ref))
      (timr (set-state-ref state (untimr state))))
    (_
      (erlang:start_timer (state-tick state) (self) #()))))

(defun untimr (state)
  (catch
    (erlang:cancel_timer (state-ref state))
    '()))

(defun send-data
  (((= (match-state old-data '()) state))
    (set-state-old-data state (get-proc-data state)))
  (((= (match-state old-data old-data) state))
    (let ((data (get-proc-data state)))
      (! (state-client state) `#(data ,(top-util:sort (state-key state)
                                                      (state-rows state)
                                                      data
                                                      old-data)))
      (set-state-old-data state data))))

(defun get-proc-data
  (((match-state tags tags-var))
    (lists:map (lambda (pid) `#(,pid ,(get-tag-group pid tags-var)))
               (processes))))

(defun get-tag-group (pid tags)
  (lists:map (lambda (tag) (get-proc-info pid tag))
             tags))

(defun get-proc-info
  ((pid 'reds)
    (get-proc-info pid 'reductions 0))
  ((pid 'mem)
    (+ (get-proc-info pid 'heap_size 0)
       (get-proc-info pid 'stack_size 0)))
  ((pid 'msgq)
    (get-proc-info pid 'message_queue_len 0))
  ((pid 'reg)
    (case (->str pid 'registered_name)
      ("[]"
        (->str pid 'initial_call))
      (x
        x))))

(defun get-proc-info (pid tag d)
  (case (catch (erlang:process_info pid tag))
    (`#(,tag ,v)
      v)
    (_
      d)))

(defun ->str (pid tag)
  (top-util:->str (get-proc-info pid tag "")))

(defun get-reductions
  (('() '() x)
    x)
  (((cons `#(,p1 (,a ,b ,c ,r)) data)
    (cons `#(,p2 (,_ ,_ ,_ ,old-r)) old)
    x) (when (== p1 p2))
    (get-reductions data old (cons `(,a ,b ,c ,(- r old-r)) x)))
  (((cons `#(,p1 ,_) data)
    (= (cons `#(,p2 ,_) ,_) old)
    x) (when (< p1 p2))
    (get-reductions data old x))
  (((= (cons `#(,p1 ,_) ,_) data)
    (cons `#(,p2 ,_) old)
    x) (when (< p2 p1))
    (get-reductions data old x))
  (('() _ x)
    (get-reductions '() '() x))
  ((_ '() x)
    (get-reductions '() '() x)))

