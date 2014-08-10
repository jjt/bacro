var Game, GameModel, MicroEvent, acronym, fb, letters, md5, now, nowISO, randStr, randomWords, salt, states, ucFirst, _,
  __hasProp = {}.hasOwnProperty,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

randStr = require('./randStr');

states = require('./gameStates');

fb = require('./firebase');

_ = require('lodash');

salt = require('./salt');

md5 = require('MD5');

randomWords = require('random-words');

letters = require('./letters');

MicroEvent = require('microevent');

GameModel = require('../app/models/game');

acronym = function(len) {
  var ret;
  if (len == null) {
    len = 3;
  }
  ret = '';
  while (len--) {
    ret += String.fromCharCode(_.random(65, 90));
  }
  return ret;
};

now = function() {
  return (new Date).getTime();
};

nowISO = function() {
  return (new Date).toISOString();
};

ucFirst = function(str) {
  return str.slice(0, 1).toUpperCase() + str.slice(1);
};

Game = (function() {
  function Game(model) {
    if (model == null) {
      model = new GameModel;
      model.save();
    }
    this.model = model;
    this.id = this.model.id.toString();
    this.timeouts = [];
    this.fbRef = fb.child("games/" + this.id);
    this.bindEvents({
      'game:start': this.persistGameLocal,
      'round:start': this.persistGame,
      'answer:start': this.persistGame,
      'answer:end': this.persistGameLocal,
      'vote:start': this.persistGame,
      'vote:end': this.persistGame,
      'round:end': this.persistGameLocal,
      'game:end': this.persistGameLocal,
      'vote': this.persistGameLocal,
      'bacronym': this.persistGameLocal,
      'players:added': this.persistGame
    });
  }

  Game.prototype.addPlayers = function(players) {
    if (!_.isArray(players)) {
      players = [players];
    }
    players.forEach((function(_this) {
      return function(player) {
        return _this.initScore(player);
      };
    })(this));
    this.model.data.players = _.uniq(this.model.data.players.concat(players), function(player) {
      return player.id;
    });
    return this.trigger('players:added', 'players:added', players);
  };

  Game.prototype.bindEvents = function(obj) {
    return _.forEach(obj, (function(_this) {
      return function(fn, trigger) {
        return _this.bind(trigger, fn.bind(_this, trigger));
      };
    })(this));
  };

  Game.prototype.clearTO = function() {
    var timeout, _i, _len, _ref;
    _ref = this.timeouts;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      timeout = _ref[_i];
      clearTimeout(timeout);
    }
    return this.timeouts = [];
  };

  Game.prototype.setTO = function(fn, delay) {
    return this.timeouts.push(setTimeout(fn.bind(this), delay));
  };

  Game.prototype.currentRound = function() {
    var round;
    round = this.model.data.rounds[this.model.data.roundNum];
    return round;
  };

  Game.prototype.persistGame = function(trigger) {
    this.persistGameLocal();
    return this.persistGameToFirebase(trigger);
  };

  Game.prototype.persistGameLocal = function() {
    return this.model.save((function(_this) {
      return function(err, model) {
        if (err != null) {
          return console.log('persistGameLocal  ERR', err, model);
        }
      };
    })(this));
  };

  Game.prototype.persistGameToFirebase = function(trigger) {
    return this.fbRef.set(this.getForFirebase(trigger));
  };

  Game.prototype.getForFirebase = function(trigger) {
    var anonUsers, bacronyms, bacronymsObj, game, round;
    game = (this.model.toObject()).data;
    game.scores = _.reduce(game.scores, function(accum, score, userId) {
      var user;
      user = _.find(game.players, {
        id: userId
      });
      accum[user.name] = score;
      return accum;
    }, {});
    if (trigger === 'vote:start') {
      round = game.rounds[this.model.data.roundNum];
      anonUsers = _.keys(round.bacronyms).map(function(el) {
        return md5(el + salt + round.roundNum).slice(0, 8);
      });
      bacronyms = _.values(round.bacronyms);
      bacronymsObj = _.zipObject(anonUsers, bacronyms);
      round.bacronyms = bacronymsObj;
      delete game.rounds[this.model.data.roundNum].votes;
      game.rounds[this.model.data.roundNum] = round;
    }
    return game;
  };

  Game.prototype.startGame = function() {
    this.model.data.gameState = 'started';
    this.setScores();
    return this.nextRound();
  };

  Game.prototype.nextRound = function() {
    this.clearTO();
    this.model.data.roundNum = this.model.data.rounds.length;
    if (this.model.data.roundNum === this.model.opts.numRounds) {
      return this.endGame();
    }
    if (this.model.data.roundNum === 0) {
      this.trigger('game:start', 'game:start');
    }
    acronym = letters.randomLetters(_.random(3, 6)).join('').toUpperCase();
    this.model.data.rounds.push({
      acronym: acronym,
      bacronyms: {},
      time: acronym.length * this.model.opts.answerTimePerLetter,
      phase: 'start',
      started: nowISO(),
      roundNum: this.model.data.roundNum,
      votes: {}
    });
    this.trigger("round:start", "round:start", this.model.data.roundNum);
    this.persistGameToFirebase;
    return this.setTO(this.startAnswer, this.model.opts.startTime);
  };

  Game.prototype.startAnswer = function() {
    this.clearTO();
    this.currentRound().phase = 'answer';
    this.trigger("answer:start", "answer:start", this.model.data.roundNum);
    return this.setTO(this.endAnswer, this.currentRound().acronym.length * this.model.opts.answerTimePerLetter);
  };

  Game.prototype.endAnswer = function() {
    this.clearTO();
    this.trigger("answer:end", "answer:end", this.model.data.roundNum);
    return this.setTO(this.startVote, this.model.opts.bufferTime);
  };

  Game.prototype.startVote = function() {
    this.clearTO();
    this.currentRound().phase = 'vote';
    this.trigger("vote:start", "vote:start", this.model.data.roundNum);
    return this.setTO(this.endVote, this.model.opts.voteTime);
  };

  Game.prototype.endVote = function() {
    this.clearTO();
    this.currentRound().phase = 'end';
    this.setVotesOnBacronyms();
    this.setScores();
    this.trigger("vote:end", "vote:end", this.model.data.roundNum);
    return this.setTO(this.endRound, this.model.opts.voteEndTime);
  };

  Game.prototype.endRound = function() {
    this.clearTO();
    this.trigger('round:end', 'round:end', this.model.data.roundNum);
    return this.nextRound();
  };

  Game.prototype.endGame = function() {
    this.model.data.gameState = 'ended';
    return this.trigger('game:end', 'game:end');
  };

  Game.prototype.submitBacronym = function(bacronym, user, time, votes) {
    if (time == null) {
      time = nowISO();
    }
    if (votes == null) {
      votes = [];
    }
    this.model.data.rounds[this.model.data.roundNum].bacronyms[user.id] = {
      bacronym: bacronym,
      time: time,
      votes: votes
    };
    return this.trigger('bacronym', {
      user: user,
      bacronym: bacronym,
      time: time,
      votes: votes
    });
  };

  Game.prototype.submitVote = function(bacronym, voter) {
    var bacronymObj, user, _ref, _results;
    _ref = this.currentRound().bacronyms;
    _results = [];
    for (user in _ref) {
      if (!__hasProp.call(_ref, user)) continue;
      bacronymObj = _ref[user];
      if (bacronymObj.bacronym === bacronym) {
        this.currentRound().votes[voter.id] = user;
        this.trigger('vote', {
          voter: voter,
          user: user,
          bacronym: bacronym
        });
        break;
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  Game.prototype.initScore = function(player) {
    return this.model.data.scores[player.id] = 0;
  };

  Game.prototype.getFreshScoreObj = function() {};

  Game.prototype.setVotesOnBacronyms = function() {
    var round, voteCounts, voteCountsKeys;
    round = this.currentRound();
    voteCounts = _.countBy(round.votes);
    voteCountsKeys = _.keys(voteCounts);
    return round.bacronyms = _.reduce(round.bacronyms, function(accum, obj, user) {
      var votes;
      votes = 0;
      if (__indexOf.call(voteCountsKeys, user) >= 0) {
        votes = voteCounts[user];
      }
      obj.votes = votes;
      accum[user] = obj;
      return accum;
    }, {});
  };

  Game.prototype.setScores = function() {
    var candidate, player, round, scores, voter, _i, _j, _len, _len1, _ref, _ref1, _ref2;
    scores = {};
    _ref = this.model.data.players;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      player = _ref[_i];
      if (scores[player.id] == null) {
        scores[player.id] = 0;
      }
    }
    _ref1 = this.model.data.rounds;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      round = _ref1[_j];
      _ref2 = round.votes;
      for (voter in _ref2) {
        candidate = _ref2[voter];
        if (scores[candidate] == null) {
          scores[candidate] = 0;
        }
        scores[candidate]++;
      }
    }
    return this.model.data.scores = scores;
  };

  return Game;

})();

MicroEvent.mixin(Game);

module.exports = Game;
