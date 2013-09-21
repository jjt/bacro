express = require 'express'
http = require 'http'
passport = require 'passport'

require('./config/passport')(passport)

app = express()
require('./config/config')(app)

# Require routes
fs = require 'fs'
path = require 'path'
routeDir = 'routes'
for file in fs.readdirSync routeDir
  routePath = path.resolve "./#{routeDir}", file
  require(routePath)(app)


http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get('port')
