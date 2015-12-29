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


### GTK Theme

By default, lfe-gtknode-example uses a custom dark theme. You can skip the loading of the dark theme configuration by setting the ``gtk -> dark-theme`` value to ``false`` in the ``lfe.config`` file for this project.
