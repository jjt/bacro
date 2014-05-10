# Simple module to persist game to local Mongo DB
# TODO: Create schema and move all data domain code out of lib/game
mongoose = require('mongoose')
randStr = require('../../lib/randStr')

gameSchema = new mongoose.Schema
  opts:
    numRounds: type: Number, default: 8
    answerTime: type: Number, default: 3000
    bufferTime: type: Number, default: 500
    voteTime: type: Number, default: 3000
    voteEndTime: type: Number, default: 1000
  data:
    rounds: type: Array, default: []
    roundNum: type: Number, default: 0
    gameState: type: String, default: 'new'
    scores: type: mongoose.Schema.Types.Mixed, default: {}
    players: type: Array, default: []


module.exports = mongoose.model 'Game', gameSchema
