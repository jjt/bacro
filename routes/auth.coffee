module.exports = (app) ->

  passport = require 'passport'

  app.get '/auth/google', passport.authenticate 'google'

  googleAuthRedirs = successRedirect: '/game/lobby', failureRedirect: '/auth/google/error'
  app.get '/auth/google/return', passport.authenticate 'google', googleAuthRedirs

  app.get '/auth/google/error', (req, res) ->
    res.send 'UH OH'

  app.get '/auth/login', (req, res) ->
    res.send 'Login from the <a href="/">front page</a>, champ'

  app.get '/auth/logout', (req, res) ->
    req.logout()
    res.redirect '/auth/loggedout'
  app.get '/auth/loggedout', (req, res) ->
    res.render 'page',
      pageHeader: 'All logged out, champ'
      content: 'Sorry to see you go &mdash; hope to see you again soon!'
