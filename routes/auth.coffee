module.exports = (app) ->

  passport = require 'passport'

  app.get '/auth/google', passport.authenticate 'google'

  googleAuthRedirs = successRedirect: '/game/lobby', failureRedirect: '/auth/google/error'
  app.get '/auth/google/return', passport.authenticate 'google', googleAuthRedirs

  app.get '/auth/google/error', (req, res) ->
    res.send 'UH OH'

  app.get '/login', (req, res) ->
    res.send 'Login from the <a href="/">front page</a>, champ'

  app.get '/logout', (req, res) ->
    res.send 'Logout? You\'re probably not even hardly logged in I bet!'
