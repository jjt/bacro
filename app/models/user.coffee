mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/bacro'

User = mongoose.model 'User',
  name: String
  email: String

exports = User
