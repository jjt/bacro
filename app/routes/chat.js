module.exports = function (app, passport) {
  var chat = require('../controllers/chat');
  app.post('/chat', chat.chat)
}
