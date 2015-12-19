-module(top_widgets).

-export([treeview_init/1]).

-include("include/top.hrl").

treeview_init(St) ->
  %% the tree view columns
  Cols = [#column{title="Process",attr="text",data_col=0,type=string},
          #column{title="Size",attr="text",data_col=1,type=integer},
          #column{title="Message Queue",attr="text",data_col=2,type=integer},
          #column{title="Reduction Count",attr="text",data_col=3,type=integer}],
  lists:foreach(fun(C) -> treeview_column(C) end, Cols),

  %% create the model (a list_store)
  LS = top_gui:ssnd([],'Gtk_list_store_newv',[length(Cols),[C#column.type||C<-Cols]]),

  %% associate the model with the view
  top_gui:ssnd(treeview1,'Gtk_tree_view_set_model',[LS]),

  St#app{treeview=#treeview{cols = Cols,
                            store = LS}}.

treeview_column(#column{title=Title,attr=Attr,data_col=Col}) ->
  %% create a tree view column
  TreeViewCol = top_gui:ssnd([],'Gtk_tree_view_column_new',[]),
  TextRend = top_gui:ssnd([],'Gtk_cell_renderer_text_new',[]),
  top_gui:ssnd(TreeViewCol,'Gtk_tree_view_column_pack_start',[TextRend,false]),
  top_gui:ssnd(TreeViewCol,'Gtk_tree_view_column_set_title',[Title]),
  top_gui:ssnd(TreeViewCol,'Gtk_tree_view_column_add_attribute',[TextRend,Attr,Col]),
  top_gui:ssnd(TreeViewCol,'Gtk_tree_view_column_set_resizable',[true]),
  top_gui:ssnd(treeview1,'Gtk_tree_view_append_column',[TreeViewCol]).
