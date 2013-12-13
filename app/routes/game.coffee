module.exports = (app) ->
 
  GameController = require('../controllers/game.coffee')(app)

  app.get '/game/new', GameController.newGame.bind GameController

  app.post '/game/:id/post/', GameController.post.bind GameController

  app.get '/game/:id/join', GameController.joinGame.bind GameController

  app.get '/game/:id/:action?', GameController.gameAction.bind GameController
