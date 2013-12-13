module.exports = (app) ->
  mongoose = require 'mongoose'
  supergoose = require 'supergoose'
  Schema = mongoose.Schema
  randomString = require 'random-string'
  User = require './user.coffee'

  gameSchema = new Schema
    name: String
    created:
      type: Date
      default: Date.now
    id:
      type: String
      default: randomString

  gameSchema.plugin supergoose

  gameSchema.methods.addUser = (user) ->
    @users ?= []
    @users.push user
    this
      

  Game = mongoose.model 'Game', gameSchema

