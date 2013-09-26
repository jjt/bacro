express = require 'express'
http = require 'http'
passport = require 'passport'
process.chdir('app')
module.exports = () ->

  require('./config/passport')(passport)

  app = express()
  require('./config/config')(app, passport)

  # Require routes
  require('./routes/all.coffee')(app)


  http.createServer(app).listen app.get('port'), ->
    console.log 'Express server listening on port ' + app.get('port')

  app
