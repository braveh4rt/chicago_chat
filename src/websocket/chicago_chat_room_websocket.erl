-module(chicago_chat_room_websocket, [Req, SessionId]).
-behaviour(boss_service_handler).
-compile(export_all).

init() ->
  io:format(",,,,,,,,,,,, Chat server has started.~n", []),
  {ok, []}.

handle_join(ServiceURL, WebSocket, State) ->
  io:format(",,,,,,,,,,,, New client has joined!~n", []),
  WebSocket ! {text, server_message(<<"Welcome chatter!">>)},
  {noreply, State}.

handle_close(Reason, ServiceURL, WebSocket, State) ->
  {State, State}.

handle_incoming(ServiceURL, WebSocket, Message, State) ->
  io:format("~p~n", [Message]),
  {noreply, [Message | State]}.

handle_info(Info, State) ->
  {noreply, State}.

handle_broadcast(Message, State) ->
  {noreply, State}.

terminate(Reason, State) ->
  ok.

server_message(Body) ->
  Json = [{nick, server}, {body, Body}],
  mochijson2:encode(Json).
