# lfe-gtknode-example


## Dependencies

* Erlang
* libglade2 and its development files


## Usage

```bash
$ rebar get-deps
$ rebar compile
$ erl -pa ./ebin -pa ./deps/gtknode/ebin -sname test -s top
```

This will bring up a GTK window. In the ``File`` menu, click ``Connect``. In a
few seconds you should see a list of running Erlang processes.
