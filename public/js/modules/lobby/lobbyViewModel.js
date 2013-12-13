define(['ko', './lobbySock', '../chat/chatViewModel', '../chat/chatSock'], function(ko, lobbySock, ChatViewModel, chatSock) {
  var $chat, ChatVM, chatVM, lobbyViewModel;
  lobbyViewModel = function() {
    return this;
  };
  $chat = $('#Chat').get(0);
  ChatVM = ChatViewModel('lobby');
  chatVM = new ChatVM;
  ko.applyBindings(chatVM, $chat);
  return lobbyViewModel;
});
