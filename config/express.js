var express = require('express')
  , session = require('express-session')
  , mongoStore = require('connect-mongo')({session: session})
  , flash = require('connect-flash')
  , winston = require('winston')
  , helpers = require('view-helpers')
  , pkg = require('../package.json')
  , compression = require('compression')
  , morgan = require('morgan')

var env = process.env.NODE_ENV || 'development'

module.exports = function (app, config, passport) {

  app.set('showStackError', true)

  // should be placed before express.static
  app.use(compression({
    filter: function (req, res) {
      return /json|text|javascript|css/.test(res.getHeader('Content-Type'))
    },
    level: 9
  }))

  //app.use(require('static-favicon')())
  app.use(express.static(config.root + '/public'))

  // Logging
  // Use winston on production
  var log
  if (env !== 'development') {
    log = {
      stream: {
        write: function (message, encoding) {
          winston.info(message)
        }
      }
    }
  } else {
    log = 'dev'
  }
  // Don't log during tests
  if (env !== 'test') app.use(morgan(log))

  // set views path, template engine and default layout
  app.set('views', config.root + '/app/views')
  app.set('view engine', 'jade')

  // expose package.json to views
  app.use(function (req, res, next) {
    res.locals.pkg = pkg
    next()
  })

  // cookieParser should be above session
  app.use(require('cookie-parser')());

  // bodyParser should be above methodOverride
  app.use(require('body-parser')());
  app.use(require('method-override')());

  // express/mongo session storage
  app.use(session({
    secret: pkg.name,
    store: new mongoStore({
      url: config.db,
      collection : 'sessions'
    })
  }))

  // use passport session
  app.use(passport.initialize())
  app.use(passport.session())

  // connect flash for flash messages - should be declared after sessions
  app.use(flash())

  // should be declared after session and flash
  app.use(helpers(pkg.name))

  // adds CSRF support
  if (process.env.NODE_ENV !== 'test') {
    app.use(require('csurf')())

    // This could be moved to view-helpers :-)
    app.use(function(req, res, next){
      res.locals.csrf_token = req.csrfToken()
      next()
    })
  }

  // routes should be at the last

  // development env config
  if(process.env.NODE_ENV === 'development')
    app.locals.pretty = true
}
