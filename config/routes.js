fs = require('fs')
/*!
 * Module dependencies.
 */

var async = require('async')

/**
 * Controllers
 */

var users = require('../app/controllers/users')
  , auth = require('./middlewares/authorization')
  , chat = require('../app/controllers/chat')

/**
 * Route middlewares
 */

var commentAuth = [auth.requiresLogin, auth.comment.hasAuthorization]


/**
 * Expose routes
 */

module.exports = function (app, passport) {

  var games = require('../app/controllers/games')(app);

  // user routes
  app.get('/user', auth.requiresLogin, users.getCurrentUser)
  app.get('/login', users.login)
  app.get('/signup', users.signup)
  app.get('/logout', users.logout)
  app.post('/users', users.create)
  app.post('/users/session',
    passport.authenticate('local', {
      failureRedirect: '/login',
      failureFlash: 'Invalid email or password.'
    }), users.session)
  app.get('/users/:userId', users.show)
  app.get('/auth/facebook',
    passport.authenticate('facebook', {
      scope: [ 'email', 'user_about_me'],
      failureRedirect: '/login'
    }), users.signin)
  app.get('/auth/facebook/callback',
    passport.authenticate('facebook', {
      failureRedirect: '/login'
    }), users.authCallback)
  app.get('/auth/github',
    passport.authenticate('github', {
      failureRedirect: '/login'
    }), users.signin)
  app.get('/auth/github/callback',
    passport.authenticate('github', {
      failureRedirect: '/login'
    }), users.authCallback)
  app.get('/auth/twitter',
    passport.authenticate('twitter', {
      failureRedirect: '/login'
    }), users.signin)
  app.get('/auth/twitter/callback',
    passport.authenticate('twitter', {
      failureRedirect: '/login'
    }), users.authCallback)
  app.get('/auth/google',
    passport.authenticate('google', {
      failureRedirect: '/login',
      scope: [
        'https://www.googleapis.com/auth/userinfo.profile',
        'https://www.googleapis.com/auth/userinfo.email'
      ]
    }), users.signin)
  app.get('/auth/google/callback',
    passport.authenticate('google', {
      failureRedirect: '/login'
    }), users.authCallback)
  app.get('/auth/linkedin',
    passport.authenticate('linkedin', {
      failureRedirect: '/login',
      scope: [
        'r_emailaddress'
      ]
    }), users.signin)
  app.get('/auth/linkedin/callback',
    passport.authenticate('linkedin', {
      failureRedirect: '/login'
    }), users.authCallback)

  app.param('userId', users.user)




  app.get('/game/new', games.new)
  app.post('/game/:id/answer', games.answer)
  app.post('/chat', chat.chat)

  app.get('*', function(req, res){
    if(req.isAuthenticated())
      return games.app(req, res);
    res.render('index');
  });



  // article routes
  //app.param('id', articles.load)
  //app.get('/articles', articles.index)
  //app.get('/articles/new', auth.requiresLogin, articles.new)
  //app.post('/articles', auth.requiresLogin, articles.create)
  //app.get('/articles/:id', articles.show)
  //app.get('/articles/:id/edit', articleAuth, articles.edit)
  //app.put('/articles/:id', articleAuth, articles.update)
  //app.del('/articles/:id', articleAuth, articles.destroy)




  // comment routes
  //var comments = require('../app/controllers/comments')
  //app.param('commentId', comments.load)
  //app.post('/articles/:id/comments', auth.requiresLogin, comments.create)
  //app.get('/articles/:id/comments', auth.requiresLogin, comments.create)
  //app.del('/articles/:id/comments/:commentId', commentAuth, comments.destroy)

  // tag routes
  //var tags = require('../app/controllers/tags')
  //app.get('/tags/:tag', tags.index)
  
  // assume "not found" in the error msgs
  // is a 404. this is somewhat silly, but
  // valid, you can do whatever you like, set
  // properties, use instanceof etc.
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
