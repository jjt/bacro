module.exports = (app, passport) ->
  express = require 'express'
  path = require 'path'
  middle = require('../middle')(app)

  app.configure ->
    app.set 'port', process.env.PORT or 3000
    app.set 'views', path.join __dirname, '../views'
    app.set 'view engine', 'jade'
    app.use express.favicon()
    app.use express.logger('dev')
    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.methodOverride()
    # Session and cookie config
    require(path.join __dirname, './config-local')(app, express)
    app.use passport.initialize()
    app.use passport.session()
    app.use middle.setAuthLocals
    app.use app.router
    app.use express.static(path.join(__dirname, '../../public'))

  app.configure 'development', ->
    app.use express.errorHandler
      dumpExceptions: true
      showStack: true

