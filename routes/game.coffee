module.exports = (app) ->

  app.get '/game/lobby', (req, res) ->
    res.send 'Game Lobby'

  app.get '/game/:id', (req, res) ->
    gameId = req.params.id
    res.send "Game with id: #{gameId}"
  
