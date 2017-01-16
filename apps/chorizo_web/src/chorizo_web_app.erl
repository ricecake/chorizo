%%%-------------------------------------------------------------------
%% @doc chorizo_web public API
%% @end
%%%-------------------------------------------------------------------

-module(chorizo_web_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    chorizo_web_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

determine_options() ->
	WithIp = case application:get_env(chorizo_web, ip) of
		undefined -> [];
		{ok, IpString} when is_list(IpString) ->
			{ok, Ip} = inet_parse:address(IpString),
			[{ip, Ip}];
		{ok, IpTuple} when is_tuple(IpTuple) -> [{ip, IpTuple}]
	end,
	Port = application:get_env(chorizo_web, port, 8080),
	{ok, [{port, Port} |WithIp]}.
