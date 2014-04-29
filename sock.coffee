http = require('http')
sockjs = require('sockjs')
websocketMultiplex = require('websocket-multiplex')

game = require('lib/game')

service = sockjs.createServer()
multiplexer = new websocketMultiplex.MultiplexServer(service)

connections = []
games = []

lobby = multiplexer.registerChannel 'echo'
lobby.on 'connection', (conn)->
  connections.push conn
  number = connections.length
  console.log 'connection', conn
  conn.write "Welcome, User #{number}"
  conn.on 'data', (msg)->
    for connection in connections
      connection.write "#{number}: #{msg}"

  conn.on 'close', (msg)->
    for connection in connections
      connection.write "#{number} dis'd"

server = http.createServer()
console.log 'BACRO SOCK'
service.installHandlers server, prefix: 'sock'
server.listen 9999
