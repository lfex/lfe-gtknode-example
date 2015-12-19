-define(GTK_VERSION, "gtk-2.0").

-record(app, {statusbar_ctxt, treeview}).
-record(treeview, {store, cols=[]}).
-record(column, {title, attr, data_col, type}).
