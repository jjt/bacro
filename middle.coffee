module.exports =
  setAuthLocals: (req, res, next) ->
    if req.session.passport.user?
      res.locals.user =
        email: req.session.passport.user.emails[0].value
        name: req.session.passport.user.displayName[0].value
    next()
