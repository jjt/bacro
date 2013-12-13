define [ 'socketio' ], (io) ->
  (namespace) ->
    socket = io.connect "http://bacro.node/chat/#{namespace}"
    console.log "socket with namespace: #{namespace}"
    console.log io.sockets
    window.onBeforeUnload = () ->
      socket.disconnect()
    socket
