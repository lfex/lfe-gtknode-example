# lfe-gtknode-example


[![][screenshot]][screenshot]

[screenshot]: resources/images/screenshot.png

## Dependencies

* Erlang
* ``rebar``
* GNU ``make``
* ``libglade2`` and its development files
* ``gtk2-engines`` and ``gtk2-engines-pixbuf`` to support the dark theme


## Usage

```bash
$ make
```

This will:

1. Download all the dependencies
1. Compile source (as well as that of its dependencies), and
1. Bring up a GTK window.

In the ``File`` menu, click ``Connect``. In a few seconds you should see a list of running Erlang processes.

To disable the dark theme, simply comment out the ``GTK2_RC_FILES`` setting in the ``Makefile``.
