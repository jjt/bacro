var GameModel;

GameModel = require('../app/models/game');

module.exports = function(ggErr, id, next) {
  console.log('getGameFromDB', id);
  return GameModel.findById(id, function(err, model) {
    var Game, game;
    if (err) {
      console.log('lib/getGame ERR', err, model);
      return next({
        code: 500,
        msg: "Something got effed up"
      });
    }
    if (model == null) {
      return next({
        code: 400,
        msg: "Couldn't find game " + id
      });
    }
    Game = require('./game');
    game = new Game(model);
    return next(null, game);
  });
};
