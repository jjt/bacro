module.exports = (app) ->

  app.get '/game/lobby', (req, res) ->
    res.render 'lobby'

  app.get '/game/:id', (req, res) ->
    gameId = req.params.id
    res.render 'game',
      gameId: gameId
  
