$(function() {
  var $chat = $("#chat");
  var $nick = null;
  var $wsc  = null;

  appendChat({nick: "Sebastian", body: "Hi there!"});
  appendChat({nick: "Jodoz", body: "Make the chat!"});
  appendChat({nick: "Sebastian", body: "Ok..."});

  $("#nick").click(onNickClick);
  $("#say").click(onSayClick);

  function appendChat(message) {
    li = $("<li></li>");
    li.append($("<span></span>").addClass("nick").text(message.nick + ": "));
    li.append($("<span></span>").addClass("body").text(message.body));
    $chat.append(li);
  }

  function onNickClick() {
    $nick = $("#nick_text").val();
    $("#nick_controls").hide();
    $("#say_controls").show();
    initWsc();
  }

  function onSayClick() {
    var body = $("#say_text").val();
    say(body);
  }

  function initWsc() {
    $wsc = new WebSocket("ws://localhost:8001/websocket/room", "room");
    $wsc.onopen = onWsOpen;
    $wsc.onerror = onWsError;
    $wsc.onmessage = onIncomingWsMessage;
  }

  function say(body) {
    var msg = {nick: $nick, body: body};
    appendChat(msg);
    $wsc.send(JSON.stringify(msg));
  }

  function onIncomingWsMessage(wsMessage) {
    var msg = JSON.parse(wsMessage.data);
    appendChat(msg);
  }

  function onWsOpen() {
    console.log("Connected to chatroom.");
  }

  function onWsError(error){
    alert("WEBSOCKET ERROR: " + error);
  }

})
