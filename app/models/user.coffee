#module.exports = (app) ->
console.log 'APP MODELS USER'
mongoose = require '../config/mongoose'
supergoose = require 'supergoose'

userSchema = mongoose.Schema
  name: String
  email: String
  dispname: String

userSchema.plugin supergoose

User = mongoose.model 'User', userSchema
module.exports = User

