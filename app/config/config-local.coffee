module.exports = (app, express) ->
  MongoStore = require('connect-mongo')(express)
  app.use express.session
    secret:'4cc32f06769b82'
    maxAge: new Date(Date.now() + 3600000)
    store: new MongoStore
      db: 'bacro'
