var Game, GameModel, Gamelist, fb, getGameFromDB, log, names, randStr, testUsers, _;

fb = require('../../lib/firebase');

Game = require('../../lib/game');

names = require('../../lib/names');

Gamelist = require('../../lib/gamelist');

GameModel = require('../models/game');

randStr = require('../../lib/randStr');

getGameFromDB = require('../../lib/getGameFromDB');

_ = require('lodash');

log = function() {
  return console.log.apply(null, arguments);
};

testUsers = _.sample(names, 8);

module.exports = function(app) {
  var Games;
  Games = {
    app: function(req, res) {
      return res.render('game/index', {
        user: req.user
      });
    },
    get: function(req, res) {
      return res.status(200).json({
        id: req.game.id,
        players: req.game.model.data.players,
        opts: req.game.model.opts
      });
    },
    clearFb: function() {
      return fb.child('games').remove();
    },
    start: function(req, res) {
      req.game.startGame();
      return res.status(200).json(req.game.getForFirebase());
    },
    "new": function(req, res) {
      var game, setGamelist;
      game = new Game();
      game.addPlayers({
        name: req.user.name,
        id: req.user.id
      });
      setGamelist = function() {
        console.log('setGamelist');
        return Gamelist.set(game);
      };
      Gamelist.set(game);
      game.bind('game:start', setGamelist);
      game.bind('round:start', setGamelist);
      game.bind('game:end', setGamelist);
      app.games.push(game);
      console.log("games.new added game " + game.id + " to list", req.games.length, _.pluck(req.games, 'id'));
      return res.status(200).json(game.id);
    },
    join: function(req, res) {
      req.game.addPlayers({
        name: req.user.name,
        id: req.user.id
      });
      Gamelist.set(req.game);
      return res.status(200).json({
        msg: 'Welcome to the game, friendo!'
      });
    },
    answer: function(req, res) {
      req.game.submitBacronym(req.param('bacronym'), req.user);
      return res.send(200, 'answer OK');
    },
    vote: function(req, res) {
      req.game.submitVote(req.param('bacronym'), req.user);
      return res.send(200, 'vote OK');
    }
  };
  return Games;
};
