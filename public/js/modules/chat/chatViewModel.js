define(['ko', './chatSock'], function(ko, chatSock) {
  return function(sockNamespace) {
    var $chat, $chatChats, $chatInput, ChatViewModel, socket;
    socket = chatSock(sockNamespace);
    $chat = $('#Chat');
    $chatInput = $('#Chat-input').get(0);
    $chatChats = $('#Chat-chats');
    socket.on('chat', function(msg) {
      console.log(msg);
      return $chatChats.prepend(msg + '<br>');
    });
    $chat.on('submit', function(event) {
      event.preventDefault();
      socket.emit('chatSent', $chatInput.value);
      $chat.value = '';
      return false;
    });
    ChatViewModel = function() {
      var self,
        _this = this;
      console.log('ChatViewModel');
      self = this;
      this.chatSubmit = function(formEl) {
        console.log("chat submit");
        return alert('arst');
      };
      this.chats = ko.observable("");
      return null;
    };
    return ChatViewModel;
  };
});
