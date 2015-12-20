%%%-------------------------------------------------------------------
%%% File    : top.erl
%%% Author  : Mats Cronqvist <locmacr@mwlx084>
%%% Description :
%%%
%%% Created :  9 Aug 2005 by Mats Cronqvist <locmacr@mwlx084>
%%%-------------------------------------------------------------------
-module(top_gui).

-export([init/0]).

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
  'top-widgets':'treeview-init'(?MODULE, state_init(#app{})).

state_init(St) ->
  %% init the status bar
  Id = 'gtk.statusbar':'get-context-id'(?MODULE, statusbar1),
  'gtk.statusbar':push(?MODULE, statusbar1, Id, "connected"),
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

quit() -> gtk:stop(?MODULE).

conn(St) -> do_connect(),state_conn(St).

disc(St) -> do_disconnect(),state_disc(St).

hide_about(St) ->
  'gtk.widget':hide(?MODULE, dialog1),
  St.

show_about(St) ->
  'gtk.widget':show(?MODULE, dialog1),
  St.

update(St,Data) ->
  'gtk.widget':'freeze-child-notify'(?MODULE, treeview1),
  clear(St#app.treeview),
  populate(St#app.treeview,Data),
  'gtk.widget':'thaw-child-notify'(?MODULE, treeview1),
  St.

state_disc(St) ->
  'gtk.statusbar':push(?MODULE, statusbar1, St#app.statusbar_ctxt, "disconnected"),
  'gtk.widget':'set-sensitive'(?MODULE, connect, true),
  'gtk.widget':'set-sensitive'(?MODULE, disconnect, false),
  St.

state_conn(St) ->
  'gtk.statusbar':pop(?MODULE, statusbar1, St#app.statusbar_ctxt),
  'gtk.widget':'set-sensitive'(?MODULE, connect, false),
  'gtk.widget':'set-sensitive'(?MODULE, disconnect, true),
  St.

do_connect() -> 'top-data':assert(self()).
do_disconnect() -> 'top-data':stop().

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear(#treeview{store=LS}) ->
  'gtk.liststore':clear(?MODULE, LS).

populate(_TV, []) -> ok;
populate(TV=#treeview{store=LS, cols=Cols}, [RowData|Data]) ->
  'gtk.liststore':append(?MODULE, LS),
  populate_list_row(LS, Cols, RowData),
  populate(TV, Data).

populate_list_row(_LS, [], []) -> ok;
populate_list_row(LS, [Col|Cols], [Data|Datas]) ->
  'gtk.value':set(?MODULE, gval, Data),
  'gtk.liststore':set(?MODULE, LS, gval, Col#column.data_col),
  populate_list_row(LS,   Cols, Datas).
