define [ 'socketio' ], (io) ->
  (game) ->
    socket = io.connect "http://bacro.node/game/#{game.id}"
    #socket = io.connect "http://bacro.node/game"
    socket.on 'connect', () ->
      console.log "Welcome to #{game.id}"
