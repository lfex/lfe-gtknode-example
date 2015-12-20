-module(top_widgets).

-export([treeview_column/2]).

-include("include/top.hrl").

treeview_column(Caller, #column{title=Title, attr=Attr, data_col=Col}) ->
  %% create a tree view column
  TextRend = 'gtk.cellrenderertext':new(Caller),
  TreeViewCol = 'gtk.treeviewcolumn':new(Caller),
  'gtk.treeviewcolumn':'pack-start'(Caller, TreeViewCol, TextRend, false),
  'gtk.treeviewcolumn':'set-title'(Caller, TreeViewCol, Title),
  'gtk.treeviewcolumn':'add-attribute'(Caller, TreeViewCol, TextRend, Attr, Col),
  'gtk.treeviewcolumn':'set-resizable'(Caller, TreeViewCol, true),
  'gtk.treeview':append(Caller, treeview1, TreeViewCol).
