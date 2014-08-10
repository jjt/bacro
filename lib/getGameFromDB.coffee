GameModel = require '../app/models/game'

module.exports = (ggErr, id, next)->
  console.log 'getGameFromDB', id
  GameModel.findById id, (err, model)->
    if err
      console.log 'lib/getGame ERR', err, model
      return next code: 500, msg: "Something got effed up"
    if not model?
      return next code: 400, msg: "Couldn't find game #{id}"
    Game = require './game'
    game = new Game model
    next null, game

