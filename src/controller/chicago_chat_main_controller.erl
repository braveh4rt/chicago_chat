-module(chicago_chat_main_controller, [Req]).
-compile(export_all).

chat('GET', []) ->
  {ok, []}.
