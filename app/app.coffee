module.exports = () ->

  app = require('express')()
  http = require 'http'
  passport = require 'passport'
  process.chdir('app')

  server = http.createServer app

  require('./config/config')(app, passport)
  require('./config/passport')(passport)

  io = require('socket.io').listen server
  #require('./lib/chat')(app, io)

  #io.sockets.on 'connection', (sock) ->
    #sock.emit 'news', hello: 'world'
    #sock.on 'custoevent', (data) ->
      #console.log data
#
  #io.of('/chat/lobby').on 'connection', (sock) ->
    #console.log 'CONNECT'
    #sock.on 'chat', (msg) ->
      #console.log msg
    #sock.emit "WORD"
  
  #io.sockets.manager.onClientDisconnect
  #io.sockets.on 'connection', (sock) ->
    #sock.on 'disconnect', () ->
      #console.log 'SOCKET DISCONNECT', arguments
  app.io = io

  require('./routes/all.coffee')(app)


  app.currentGames = {}

  server.listen app.get('port'), ->
    console.log 'Express server listening on port ' + app.get('port')

  app
