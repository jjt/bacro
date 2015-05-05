module.exports = function (app, passport) {
  var games = require('../controllers/games')(app);
  var mongoose = require('mongoose');
  var User = mongoose.model('User');
  var UsersController = require('../controllers/users');

  require('./auth.js')(app, passport);
  require('./game.js')(app);
  require('./chat.js')(app);

  var addLocals = function (req, res, next) {
    console.log(req.session, req.session.returningUser);
    if(req.session.returningUser)
      res.locals.showIntro = false;
    else
      res.locals.showIntro = true;

    console.log(res.locals.showIntro);
    req.session.returningUser = true;
    next();
  };

  app.get('*', UsersController.createOrLogin, addLocals, function(req, res){
    return games.app(req, res);
  });

  app.get('/index', function(req, res){
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
