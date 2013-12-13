module.exports = (app) ->
 
  LobbyController = require('../controllers/lobby.coffee')(app)

  app.get '/lobby', LobbyController.lobby.bind LobbyController
