module.exports = () ->

  express = require 'express'
  http = require 'http'
  passport = require 'passport'
  process.chdir('app')

  require('./config/passport')(passport)

  app = express()
  require('./config/config')(app, passport)

  # Require routes
  require('./routes/all.coffee')(app)


  server = http.createServer app
  server.listen app.get('port'), ->
    console.log 'Express server listening on port ' + app.get('port')

  io = require('socket.io').listen server
  app.io = io
  #require('./lib/chat')(app, io)

  io.sockets.on 'connection', (sock) ->
    sock.emit 'news', hello: 'world'
    sock.emit '8nstuna', no: 'way'
    sock.on 'custoevent', (data) ->
      console.log data

  app
