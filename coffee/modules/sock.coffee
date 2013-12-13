define [ 'socketio' ], (io) ->
  sock = io.connect 'http://bacro.node'
  sock.on 'connection', (socket) ->
    console.log 'conanorsentaonection'
    socket.emit 'news', hello: 'arstarst'

  () ->
    sock
