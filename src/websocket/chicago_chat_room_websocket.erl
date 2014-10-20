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
  {State, State}.

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
  add_message_to_room(NewRoom, server_message(<<"Welcome chatter!">>)).

add_message_to_room(Room, Message) ->
  NewMessages = [Message | Room#room_state.clients],
  NewRoom = Room#room_state{messages = NewMessages},
  send_to_room(NewRoom, Message),
  NewRoom.

send_to_room(Room, Message) ->
  send_to_many(Room#room_state.clients, Message).

% Erlang allows simpler iteration via list module but I'm in hurry.
send_to_many([WebSocket | Tail], Message) ->
  WebSocket ! {text, Message};

send_to_many([], _) ->
  ok.
