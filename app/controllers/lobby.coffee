module.exports = (app) ->

  LobbyController =
    lobby: (req, res) ->
      #app.io.of('/lobby').emit('chat', 'Hey')
      #app.io.of('/lobby').on 'connection', (sock) ->
        #sock.on 'chatSubmit', (msg) ->
          #sock.emit msg
          #console.log msg
      chatController = require('./chat')(app, 'lobby', res)
        
      games = app.currentGames
      console.log "GAMES", games
      console.log chatController
      res.render 'lobby', { games }

