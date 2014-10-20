$(function() {
  var $chat = $("#chat");
  var $nick = null;

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
  }

  function onSayClick() {
    var body = $("#say_text").val();
    say(body);
  }

  function say(body) {
    var msg = {nick: $nick, body: body};
    appendChat(msg);
  }
})
