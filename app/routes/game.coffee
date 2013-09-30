module.exports = (app) ->

  GameController = require('../controllers/game.coffee')(app)
  app.get '/game/lobby', (req, res) ->
    res.render 'lobby'

  app.get '/game/new', GameController.newGame.bind GameController

  app.post '/game/:id/post/', GameController.post.bind GameController

  app.get '/game/:id/:action?', GameController.gameAction.bind GameController
