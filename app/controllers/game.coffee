module.exports = (app) ->
  GameModel = require('../models/game')(app)
  GameController =

    getGameParams: (params) ->
      [params?.id, params?.action]

    getGame: (params) ->
      [gameId, action] = @getGameParams params
      if gameId of app.currentGames
        return app.currentGames[gameId]
      else
        return null

    newGame: (req, res) ->
      console.log "GameController"
      game = new GameModel()
      app.currentGames[game.id] = game
      res.redirect "/game/#{game.id}"

    gameAction: (req, res) ->
      game = @getGame req.params
      if not game?
        res.status('404').render 'page',
          pageHeader: "Whoops, game not found"
          content: "Maybe you'd like to start a <a href='/game/new'>new game</a>? Or at least head back to the <a href='/lobby'>lobby</a>."
        return
      res.render 'game',
        gameId: game.id
        game: game

    joinGame: (req, res) ->
      game = @getGame req.params
      game.addUser(res.locals.user)
      res.redirect "game/#{game.id}"

    post: (req, res) ->
      resJSON =
        status: 0
        msg: 'Hey great, we got your shit'
      res.json 200, resJSON.stringify()
