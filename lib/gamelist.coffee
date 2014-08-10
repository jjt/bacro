_ = require 'lodash'
fb = require('./firebase').child 'gamelist'
GameModel = require '../app/models/game'

formatGameObj = (game)->
  model = game.model.toObject()
  model.id = model._id.toString()
  delete model._id

  id: model.id
  numPlayers: model.data.players.length
  gameState: model.data.gameState
  roundNum: model.data.roundNum
  numRounds: model.opts.numRounds
  players: model.data.players

Gamelist =
  set: (game)->
    fbGame = fb.child(game.id)
    if game.model?.data? and game.model?.data?.gameState == 'ended'
      return fbGame.remove()
    gameObj = formatGameObj game
    fbGame.set gameObj
  
  # Syncs local db to Firebase
  sync: (games)->
    games = games.reduce (accum, game)->
      accum[game.id] = formatGameObj game
      accum
    , {}
    fb.set games

module.exports = Gamelist
