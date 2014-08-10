express = require("express")
fs = require("fs")
passport = require("passport")
_ = require 'lodash'
fb = require './lib/firebase'
GameModel = require './app/models/game'
Game = require './lib/game'
GameList = require './lib/gamelist'



# Load configurations
# if test env, load example file
env = process.env.NODE_ENV or "development"
config = require("./config/config")[env]
mongoose = require("mongoose")

console.log('ENV IS ', env)

# Bootstrap db connection
# Connect to mongodb
connect = ->
  options = server:
    socketOptions:
      keepAlive: 1

  mongoose.connect config.db, options
  return

connect()

app = express()
app.games = []
# Clear fb of everything
# TODO: Sync existing games/chats/etc instead
fb.remove()



loadGamesFromDB = ()->
  GameModel.find {}, (err, gameModels)->
    console.log 'OPENOPEN', gameModels
    app.games = gameModels.map (gameModel)->
      new Game gameModel
    GameList.sync app.games

#mongoose.connection.once "open", loadGamesFromDB



# Error handler
mongoose.connection.on "error", (err) ->
  console.log 'mongoose err', err
  return


# Reconnect when closed
mongoose.connection.on "disconnected", ->
  connect()
  return


# Bootstrap models
models_path = __dirname + "/app/models"
fs.readdirSync(models_path).forEach (file) ->
  require models_path + "/" + file  if ~file.indexOf(".js")
  return

# bootstrap passport config
require("./config/passport") passport, config


# express settings
require("./config/express") app, config, passport

app.use '*', (req, res, next)->
  req.games = app.games
  next()

# Bootstrap routes
require("./app/routes") app, passport



# Start the app by listening on <port>
port = process.env.PORT or 3000
app.listen port
console.log "Express app started on port " + port

# expose app
exports = module.exports = app
