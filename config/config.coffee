module.exports = (app) ->
  express = require 'express'
  passport = require 'passport'
  path = require 'path'

  app.configure ->
    app.set 'port', process.env.PORT or 3000
    app.set 'views', path.join __dirname, '../views'
    app.use express.static(path.join(__dirname, '../public'))
    app.set 'view engine', 'jade'
    app.use express.favicon()
    app.use express.logger('dev')
    app.use express.bodyParser()
    app.use express.methodOverride()

    # Session and cookie config
    require(path.join __dirname, './config-local')(app, express)

    app.use passport.initialize()
    app.use passport.session()
    app.use app.router

  app.configure 'development', ->
    app.use express.errorHandler
      dumpExceptions: true
      showStack: true

