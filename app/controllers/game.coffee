module.exports = (app) ->
  GameModel = require '../models/game.coffee'

  GameController =
    currentGames: {}

    getGameParams: (params) ->
      [params?.id, params?.action]
    
    newGame: (req, res) ->
      console.log "GameController"
      game = new GameModel()
      @currentGames[game.id] = game
      res.redirect "/game/#{game.id}"

    gameAction: (req, res) ->
      console.log this
      [gameId, action] = @getGameParams req.params
      res.render 'game',
        gameId: gameId

    post: (req, res) ->
      resJSON =
        status: 0
        msg: 'Hey great, we got your shit'
      res.json 200, resJSON.stringify()
