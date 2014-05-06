module.exports = function (app, passport) {
  var games = require('../controllers/games')(app);
  app.get('/game/new', games.new)
  app.post('/game/:id/answer', games.answer)
}
