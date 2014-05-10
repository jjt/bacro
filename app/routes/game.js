getGame = require('../middleware/getGame');
module.exports = function (app, passport) {
  var games = require('../controllers/games')(app);
  app.get('/game/get/:id', getGame, games.get)
  app.post('/game/start', getGame, games.start)
  app.post('/game/answer', getGame, games.answer)
  app.post('/game/vote', getGame, games.vote)
  app.post('/game/join', getGame, games.join)
  app.post('/game/new', games.new)
}
