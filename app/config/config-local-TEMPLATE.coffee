module.exports = (app, express) ->
  app.use express.cookieParser('SECRETSSESS')
  app.use express.session
    secret:'SECRETSSESS'
    maxAge: new Date(Date.now() + 3600000)
