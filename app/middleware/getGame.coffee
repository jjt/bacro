GameModel = require '../models/game'
getGameFromDB = require '../../lib/getGameFromDB'
_ = require('lodash')

module.exports = (req, res, next)->
  id = req.param 'id'
  game = _.find req.games, id: req.id
  if game?
    console.log 'MW.getGame game found', game.id
    return game
  getGameFromDB null, id, (err, game)->
    if err?
      console.log 'middleware/getGameFromDB ERR', err, game
      res.status(err.code).send err.msg
      return next 'routes'

    req.game = game
    next null, game

