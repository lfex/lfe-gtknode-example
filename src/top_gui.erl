%%%-------------------------------------------------------------------
%%% File    : top.erl
%%% Author  : Mats Cronqvist <locmacr@mwlx084>
%%% Description :
%%%
%%% Created :  9 Aug 2005 by Mats Cronqvist <locmacr@mwlx084>
%%%-------------------------------------------------------------------
-module(top_gui).

-export([init/0,ssnd/3]).

-import(filename,[join/1,dirname/1]).

-include("include/top.hrl").

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init() ->
  gtk:start(?MODULE),
  %% start the c-node and it's port handler
  'gtk.rc':parse(?MODULE, ?GTK_VERSION, top),
  %% load the glade file into the c-node
  'gtk.glade':init(?MODULE, ?GTK_VERSION, top),
    loop(init_gui()).

init_gui() ->
  top_widgets:treeview_init(state_init(#app{})).

state_init(St) ->
  %% init the status bar
  Id = ssnd(statusbar1,'Gtk_statusbar_get_context_id',["state"]),
  ssnd(statusbar1,'Gtk_statusbar_push',[Id,"connected"]),
  state_disc(St#app{statusbar_ctxt = Id}).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
loop(St) ->
  receive
    %% user deleted top window
    {?MODULE,{signal,{window1,_}}}    -> quit();
    %% user selected quit menu item
    {?MODULE,{signal,{quit1,_}}}      -> quit();
    %% user selected  connect menu item
    {?MODULE,{signal,{connect,_}}}    -> loop(conn(St));
    %% user selected  disconnect menu item
    {?MODULE,{signal,{disconnect,_}}} -> loop(disc(St));
    %% user selected about menu item
    {?MODULE,{signal,{about1,_}}}     -> loop(show_about(St));
    %% user clicked ok in about dialog
    {?MODULE,{signal,{dialogb,_}}}    -> loop(hide_about(St));
    %% user deleted about dialog
    {?MODULE,{signal,{dialog1,_}}}    -> loop(hide_about(St));
    %% we got data from the top_data process
    {data,Data}                       -> loop(update(St,Data));
    %% quit from the erlang shell
    quit                              -> quit();
    %% log other signals
    X                                 -> io:fwrite("got ~p~n",[X]),loop(St)
  end.

quit() -> gtknode:stop(?MODULE).
conn(St) -> do_connect(),state_conn(St).
disc(St) -> do_disconnect(),state_disc(St).
hide_about(St) -> ssnd(dialog1,'Gtk_widget_hide',[]),St.
show_about(St) -> ssnd(dialog1,'Gtk_widget_show',[]),St.
update(St,Data) ->
  ssnd(treeview1,'Gtk_widget_freeze_child_notify',[]),
  clear(St#app.treeview),
  populate(St#app.treeview,Data),
  ssnd(treeview1,'Gtk_widget_thaw_child_notify',[]),
  St.
state_disc(St) ->
  ssnd(statusbar1,'Gtk_statusbar_push',[St#app.statusbar_ctxt,"disconnected"]),
  ssnd(connect,'Gtk_widget_set_sensitive',[true]),
  ssnd(disconnect,'Gtk_widget_set_sensitive',[false]),
  St.
state_conn(St) ->
  ssnd(statusbar1,'Gtk_statusbar_pop',[St#app.statusbar_ctxt]),
  ssnd(connect,'Gtk_widget_set_sensitive',[false]),
  ssnd(disconnect,'Gtk_widget_set_sensitive',[true]),
  St.

do_connect() -> 'top-data':assert(self()).
do_disconnect() -> 'top-data':stop().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear(#treeview{store=LS}) ->
  ssnd(LS,'Gtk_list_store_clear',[]).

populate(_TV,[]) -> ok;
populate(TV=#treeview{store=LS,cols=Cols},[RowData|Data]) ->
  ssnd(LS,'Gtk_list_store_append',[gtkTreeIter]),
  populate_list_row(LS,Cols,RowData),
  populate(TV,Data).

populate_list_row(_LS,[],[]) -> ok;
populate_list_row(LS,[Col|Cols],[Data|Datas]) ->
  ssnd(gval,'GN_value_set',[Data]),
  ssnd(LS,'Gtk_list_store_set_value',[gtkTreeIter,Col#column.data_col,gval]),
  populate_list_row(LS,Cols,Datas).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ssnd(Widget, Command, Args) ->
  gtk:ssnd(?MODULE, Widget, Command, Args).

