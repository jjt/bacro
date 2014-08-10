var GameModel, getGameFromDB, _;

GameModel = require('../models/game');

getGameFromDB = require('../../lib/getGameFromDB');

_ = require('lodash');

module.exports = function(req, res, next) {
  var game, id;
  id = req.param('id');
  game = _.find(req.games, {
    id: id
  });
  if (game != null) {
    console.log('MW.getGame game found', game.id);
    req.game = game;
    return next();
  }
  return getGameFromDB(null, id, function(err, game) {
    if (err != null) {
      console.log('middleware/getGameFromDB ERR', err, game);
      res.status(err.code).send(err.msg);
      return next('routes');
    }
    req.game = game;
    return next(null, game);
  });
};
