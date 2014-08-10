var GameModel, Gamelist, fb, formatGameObj, _;

_ = require('lodash');

fb = require('./firebase').child('gamelist');

GameModel = require('../app/models/game');

formatGameObj = function(game) {
  var model;
  model = game.model.toObject();
  model.id = model._id.toString();
  delete model._id;
  return {
    id: model.id,
    numPlayers: model.data.players.length,
    gameState: model.data.gameState,
    roundNum: model.data.roundNum,
    numRounds: model.opts.numRounds,
    players: model.data.players
  };
};

Gamelist = {
  set: function(game) {
    var fbGame, gameObj, _ref, _ref1, _ref2;
    fbGame = fb.child(game.id);
    if ((((_ref = game.model) != null ? _ref.data : void 0) != null) && ((_ref1 = game.model) != null ? (_ref2 = _ref1.data) != null ? _ref2.gameState : void 0 : void 0) === 'ended') {
      return fbGame.remove();
    }
    gameObj = formatGameObj(game);
    return fbGame.set(gameObj);
  },
  sync: function(games) {
    games = games.reduce(function(accum, game) {
      accum[game.id] = formatGameObj(game);
      return accum;
    }, {});
    return fb.set(games);
  }
};

module.exports = Gamelist;
