define [
  'ko'
  './lobbySock'
  '../chat/chatViewModel'
  '../chat/chatSock'
],
(ko, lobbySock, ChatViewModel, chatSock) ->
  lobbyViewModel = () ->
    this

  $chat = $('#Chat').get(0)

  #socket = lobbySock()
  
  ChatVM = ChatViewModel('lobby')
  chatVM = new ChatVM
  ko.applyBindings chatVM, $chat
  #chatSock socket, chatVM



  lobbyViewModel

