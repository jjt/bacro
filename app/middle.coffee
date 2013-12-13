animalonymous = require 'animalonymous'
module.exports = (app) ->
  setAuthLocals: (req, res, next) ->
    if req.session.passport.user?
      email = req.session.passport.user.emails[0].value
      name = req.session.passport.user.displayName.split(' ')[0]
      dispname = animalonymous.hashStr email
      
      res.locals.user = { email, name, dispname}
    next()

  sockAuth: (req, res, next) ->
    console.log "MIDDLE SOCKAUTH", res.locals.user
    next()
