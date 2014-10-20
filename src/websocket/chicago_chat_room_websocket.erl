-module(chicago_chat_room_websocket, [Req, SessionId]).
-behaviour(boss_service_handler).
-compile(export_all).

-record(room_state, {clients, messages}).

init() ->
  io:format(",,,,,,,,,,,, Chat server has started.~n", []),
  {ok, init_room()}.

handle_join(ServiceURL, WebSocket, State) ->
  io:format(",,,,,,,,,,,, New client has joined!~n", []),
  {noreply, add_client_to_room(State, WebSocket)}.

handle_close(Reason, ServiceURL, WebSocket, State) ->
  {noreply, remove_client_from_room(State, WebSocket)}.

handle_incoming(ServiceURL, WebSocket, Message, State) ->
  {noreply, add_message_to_room(State, Message)}.

handle_info(Info, State) ->
  {noreply, State}.

handle_broadcast(Message, State) ->
  {noreply, State}.

terminate(Reason, State) ->
  ok.

server_message(Body) ->
  Json = [{nick, server}, {body, Body}],
  mochijson2:encode(Json).

% Should be moved to separate module but I'm in hurry.

init_room() ->
  #room_state{clients = [], messages = []}.

add_client_to_room(Room, WebSocket) ->
  NewClients = [WebSocket | Room#room_state.clients],
  NewRoom = Room#room_state{clients = NewClients},
  send_many_messages(WebSocket, lists:reverse(Room#room_state.messages)),
  add_message_to_room(NewRoom, server_message(<<"Welcome chatter!">>)).

remove_client_from_room(Room, WebSocket) ->
  NewClients = lists:delete(WebSocket, Room#room_state.clients),
  NewRoom = Room#room_state{clients = NewClients},
  add_message_to_room(NewRoom, server_message(<<"Client has quit!">>)).

add_message_to_room(Room, Message) ->
  io:format(",,,,,,,,,,,, Message: ~p.~n", [Message]),
  Clients = Room#room_state.clients,
  Messages = Room#room_state.messages,
  lists:foreach(fun(WS) -> WS ! {text, Message} end, Clients),
  Room#room_state{messages = [Message | Messages]}.

send_many_messages(WebSocket, Messages) ->
  lists:foreach(fun(Msg) -> WebSocket ! {text, Msg} end, Messages).
