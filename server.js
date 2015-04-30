var Game, GameList, GameModel, app, config, connect, env, exports, express, fb, fs, loadGamesFromDB, models_path, mongoose, passport, port, _;

env = process.env.NODE_ENV || "development";

console.log('ENV IS ', env);

express = require("express");

fs = require("fs");

passport = require("passport");

_ = require('lodash');

fb = require('./lib/firebase');

GameModel = require('./app/models/game');

Game = require('./lib/game');

GameList = require('./lib/gamelist');

config = require("./config/config")[env];

mongoose = require("mongoose");

connect = function() {
  var options;
  options = {
    server: {
      socketOptions: {
        keepAlive: 1
      }
    }
  };
  mongoose.connect(config.db, options);
};

connect();

app = express();

app.use(express["static"](__dirname + '/public'));

app.use(express["static"](__dirname + '/.public'));

app.games = [];

fb.remove();

loadGamesFromDB = function() {
  return GameModel.find({}, function(err, gameModels) {
    console.log('OPENOPEN', gameModels);
    app.games = gameModels.map(function(gameModel) {
      return new Game(gameModel);
    });
    return GameList.sync(app.games);
  });
};

mongoose.connection.on("error", function(err) {
  console.log('mongoose err', err);
});

mongoose.connection.on("disconnected", function() {
  connect();
});

models_path = __dirname + "/app/models";

fs.readdirSync(models_path).forEach(function(file) {
  if (~file.indexOf(".js")) {
    require(models_path + "/" + file);
  }
});

require("./config/passport")(passport, config);

require("./config/express")(app, config, passport);

app.use('*', function(req, res, next) {
  req.games = app.games;
  return next();
});

require("./app/routes")(app, passport);

port = process.env.PORT || 3000;

app.listen(port);

console.log("Express app started on port " + port);

exports = module.exports = app;
