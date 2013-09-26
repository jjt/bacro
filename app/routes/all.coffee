module.exports = (app) ->
  fs = require 'fs'
  path = require 'path'
  routeDir = 'routes'
  for file in fs.readdirSync routeDir
    continue if file == 'all.coffee'
    routePath = path.resolve "./#{routeDir}", file
    require(routePath)(app)

