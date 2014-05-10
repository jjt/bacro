GameModel = require '../models/game'
getGameFromDB = require '../../lib/getGameFromDB'
_ = require('lodash')

module.exports = (req, res, next)->
  id = req.param 'id'
  game = _.find req.games, id: id
  console.log 'getGame', id, _.pluck(req.games, 'id'), game
  if game?
    console.log 'MW.getGame game found', game.id
    req.game = game
    return next()
  getGameFromDB null, id, (err, game)->
    if err?
      console.log 'middleware/getGameFromDB ERR', err, game
      res.status(err.code).send err.msg
      return next 'routes'
    req.game = game
    next null, game

