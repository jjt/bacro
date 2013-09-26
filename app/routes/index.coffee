module.exports = (app) ->

  app.get '/', (req, res) ->
    res.render "index",
      #suppressHeader: true
      title: "Bacro"
