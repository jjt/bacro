mongoose = require 'mongoose'
supergoose = require 'supergoose'
Schema = mongoose.Schema
randomString = require 'random-string'

gameSchema = new Schema
  name: String
  created:
    type: Date
    default: Date.now
  id:
    type: String
    default: randomString

gameSchema.plugin supergoose
Game = mongoose.model 'Game', gameSchema

module.exports = Game
