-module(top_widgets).

-export([treeview_init/2]).

-include("include/top.hrl").

treeview_init(Caller, St) ->
  %% the tree view columns
  Cols = [#column{title="Process", attr="text", data_col=0, type=string},
          #column{title="Size", attr="text", data_col=1, type=integer},
          #column{title="Message Queue", attr="text", data_col=2, type=integer},
          #column{title="Reduction Count", attr="text", data_col=3, type=integer}],
  lists:foreach(fun(C) -> treeview_column(Caller, C) end, Cols),
  %% create the model (a list_store)
  LS = 'gtk.liststore':new(Caller, length(Cols), [C#column.type||C<-Cols]),
  %% associate the model with the view
  'gtk.treeview':'set-model'(Caller, treeview1, LS),
  St#app{treeview=#treeview{cols=Cols, store=LS}}.

treeview_column(Caller, #column{title=Title, attr=Attr, data_col=Col}) ->
  %% create a tree view column
  TextRend = 'gtk.cellrenderertext':new(Caller),
  TreeViewCol = 'gtk.treeviewcolumn':new(Caller),
  'gtk.treeviewcolumn':'pack-start'(Caller, TreeViewCol, TextRend, false),
  'gtk.treeviewcolumn':'set-title'(Caller, TreeViewCol, Title),
  'gtk.treeviewcolumn':'add-attribute'(Caller, TreeViewCol, TextRend, Attr, Col),
  'gtk.treeviewcolumn':'set-resizable'(Caller, TreeViewCol, true),
  'gtk.treeview':append(Caller, treeview1, TreeViewCol).
