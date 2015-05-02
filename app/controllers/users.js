
/**
 * Module dependencies.
 */

var mongoose = require('mongoose')
  , User = mongoose.model('User')
  , utils = require('../../lib/utils')
  , randomName = require('../../lib/randomName')

var login = function (req, res) {
  var redirectTo = req.session.returnTo ? req.session.returnTo : '/'
  res.cookie('user', {
    name: req.user.name,
    id: req.user._id
  });
  delete req.session.returnTo
  res.redirect(redirectTo)
}

exports.signin = function (req, res) {
  console.log('users.signin')
}

/**
 * Auth callback
 */

exports.authCallback = login

/**
 * Show login form
 */

exports.login = function (req, res) {
  res.render('users/login', {
    title: 'Login',
    message: req.flash('error')
  })
}

/**
 * Show sign up form
 */

exports.signup = function (req, res) {
  res.render('users/signup', {
    title: 'Sign up',
    user: new User()
  })
}

/**
 * Logout
 */

exports.logout = function (req, res) {
  req.logout()
  res.redirect('/')
}

/**
 * Session
 */

exports.session = login

exports.getCurrentUser = function (req, res) {
  res.send(200, JSON.stringify({
    id: req.user._id,
    name: req.user.name
  }));
}

/**
 * Create user
 */

exports.createOrLogin = function (req, res) {
  var username = User.makeUsername(req.sessionID)
  var body = {
    name: username,
    username: username,
    email: username.replace(' ', '.') + '@nopefake.com',
    password: process.env.SALT
  }

  User
    .where({username: body.name})
    .findOne(function(err, user) {
        console.log(err, user);
        if(err || user == null) {
          user = new User(body);
          user.provider = 'local'
          user.save(function(err) {
            req.logIn(user, function(err) {
              if (err) return next(err)
              return res.redirect('/')
            })
          })
          return;
        }

        user.provider = 'local'
        req.logIn(user, function(err) {
          if (err) return next(err)
          return res.redirect('/')
        })

      });
}

/**
 *  Show profile
 */

exports.show = function (req, res) {
  var user = req.profile
  res.render('users/show', {
    title: user.name,
    user: user
  })
}

/**
 * Find user by id
 */

exports.user = function (req, res, next, id) {
  User
    .findOne({ _id : id })
    .exec(function (err, user) {
      if (err) return next(err)
      if (!user) return next(new Error('Failed to load User ' + id))
      req.profile = user
      next()
    })
}
