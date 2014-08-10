# Simple module to persist game to local Mongo DB
# TODO: Create schema and move all data domain code out of lib/game
mongoose = require('mongoose')
randStr = require('../../lib/randStr')

gameSchema = new mongoose.Schema
  opts:
    numRounds: type: Number, default: 8
    startTime: type: Number, default: 3000
    answerTime: type: Number, default: 24000
    answerTimePerLetter: type: Number, default: 6000
    answerEndTime: type: Number, default: 1000
    voteTime: type: Number, default: 10000
    voteEndTime: type: Number, default: 3000
    endTime: type: Number, default: 1000
  data:
    rounds: type: Array, default: []
    roundNum: type: Number, default: 0
    gameState: type: String, default: 'new'
    scores: type: mongoose.Schema.Types.Mixed, default: {}
    players: type: Array, default: []


module.exports = mongoose.model 'Game', gameSchema
