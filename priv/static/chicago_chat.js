$(function() {
  $chat = $("#chat")

  appendChat({nick: "Sebastian", body: "Hi there!"});
  appendChat({nick: "Jodoz", body: "Make the chat!"});
  appendChat({nick: "Sebastian", body: "Ok..."});

  function appendChat(message) {
    li = $("<li></li>");
    li.append($("<span></span>").addClass("nick").text(message.nick));
    li.append($("<span></span>").addClass("body").text(message.body));
    $chat.append(li);
  }
})
