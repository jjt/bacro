define [ 'socketio' ], (io) ->
  () ->
    socket = io.connect "http://bacro.node/lobby"
    #socket.on 'connect', () ->
      #console.log "Welcome to the lobby"

    #socket.on 'chat', (msg) ->
      #console.log msg
      #$chat.prepend "#{msg}<br>"

    return socket
