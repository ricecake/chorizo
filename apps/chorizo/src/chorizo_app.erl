%%%-------------------------------------------------------------------
%% @doc chorizo public API
%% @end
%%%-------------------------------------------------------------------

-module(chorizo_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    chorizo_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================