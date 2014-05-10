fb = require('./firebase').child 'gamelist'
Gamelist =
  set: (game)->
    model = game.model.toObject()
    model.id = model._id.toString()
    delete model._id
    fbChild = fb.child(model.id)
    fbChild.set
      numPlayers: model.data.players.length
      gameState: model.data.gameState
      roundNum: model.data.roundNum
      numRounds: model.opts.numRounds
      players: model.data.players

module.exports = Gamelist
  
