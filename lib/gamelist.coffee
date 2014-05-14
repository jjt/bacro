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
    console.log 'GAMELIST', game
    if game.model?.data?
      console.log "Gamelist #{game.model.data.gameState}"
    if game.model?.data? and game.model?.data?.gameState == 'ended'
      return fbGame.remove()
    gameObj = formatGameObj game
    fbGame.set gameObj
  
  # Syncs local db to Firebase
  sync: (games)->
    console.log games
    return
    games = games.map formatGameObj
    fb.set games

module.exports = Gamelist
