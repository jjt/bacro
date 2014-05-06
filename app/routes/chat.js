var chat = require('../controllers/chat')(app);
module.exports = function (app, passport) {
  app.post('/chat', chat.chat)
}
