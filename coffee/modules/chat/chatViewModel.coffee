define [
  'ko'
  './chatSock'
],
(ko, chatSock) ->
  (sockNamespace) ->
    socket = chatSock(sockNamespace)
    $chat = $('#Chat')
    $chatInput = $('#Chat-input').get(0)
    $chatChats = $ '#Chat-chats'

    #socket.on 'connect', () ->
      #console.log 'SOCKET: ', socket
    socket.on 'chat', (msg) ->
      console.log msg
      $chatChats.prepend msg + '<br>'

    $chat.on 'submit', (event) ->
      event.preventDefault()
      socket.emit 'chatSent', $chatInput.value
      $chat.value = ''
      false

    ChatViewModel = () ->
      console.log 'ChatViewModel'
      self = this
      @chatSubmit = (formEl) =>
        console.log "chat submit"
        alert 'arst'
      @chats = ko.observable ""
      null

    ChatViewModel
