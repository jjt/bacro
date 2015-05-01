module.exports = function (app, passport) {
  var games = require('../controllers/games')(app);
  var mongoose = require('mongoose');
  var User = mongoose.model('User');

  require('./auth.js')(app, passport);
  require('./game.js')(app);
  require('./chat.js')(app);

  app.get('*', function(req, res){
    if(req.isAuthenticated())
      return games.app(req, res);
    res.render('index', {
      username: User.makeUsername(req.sessionID)
    });
  });

  app.use(function(err, req, res, next){
    // treat as 404
    if (err.message
      && (~err.message.indexOf('not found')
      || (~err.message.indexOf('Cast to ObjectId failed')))) {
      return next()
    }

    // log it
    // send emails if you want
    console.error(err.stack)

    // error page
    res.status(500).render('500', { error: err.stack })
  })

  // assume 404 since no middleware responded
  app.use(function(req, res, next){
    res.status(404).render('404', {
      url: req.originalUrl,
      error: 'Not found'
    })
  })


}
