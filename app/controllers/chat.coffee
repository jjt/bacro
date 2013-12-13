module.exports = (app, namespace, res) ->
  
  ChatController =
    user: res.locals.user
    chatSent: (msg,sock) ->
      chatObj =
        user: @user.dispname
        msg: msg
      sock.emit 'chat', chatObj
      console.log 'CHATSENT', chatObj

  namespace = "/chat/#{namespace}"
  console.log "namespace #{namespace}"
  chatIo = app.io.of(namespace)
  chatIo.on 'connection', (client) ->
    console.log client
    client.emit 'chat', 'Welcome!!'
  chatIo.on 'chatSent', (msg) ->
    console.log 'chatSent'
    ChatController.chatSent.apply ChatController, [msg, sock]
  chatIo.on 'disconnect', () ->
    console.log "APP CONTROLLERS CHAT DISCONNECT"
  #app.io.of(namespace).on 'connection', (sock) ->
    #sock.emit 'chat', 'Welcome!!'
    #sock.on 'chatSent', (msg) ->
      #ChatController.chatSent.apply ChatController, [msg, sock]
    #sock.on 'disconnect', () ->
      #console.log "APP CONTROLLERS CHAT DISCONNECT"

  ChatController
