Game = require './views/game.cjsx'
Lobby = require './views/lobby.cjsx'
Status404 = require './views/404.cjsx'
Header = require './views/header.cjsx'
page = require ('../bower_components/page.js/index')
csrfPost = require('../../lib/csrfPost')
fb = require('./fbRoot')

show = (component, title, props={})->
  $header = document.getElementById('site-nav')
  $app = document.getElementById('app')
  headerObj =
    breadCrumbs: [title]
    username:user.name
    page: page

  header = React.createElement(Header, headerObj)
  comp = React.createElement(component, props)
  React.render header, $header
  React.render comp, $app

page '/', show.bind null, Lobby, 'Lobby'

page '/lobby', show.bind null, Lobby, 'Lobby'

page '/game/new', (ctx)->
  respFn = (gameId)->
    page.replace "/game/#{gameId}"
  failFn = ()->
    console.log arguments

  csrfPost '/game/new', newGame:'Yeah newGame!' , respFn, failFn

page '/game/:id', (ctx)->
  id = ctx.params.id
  $.ajax
    url: "/game/get/#{id}"
    success: (game)->
      if not game?
        return show Status404, "404", msg: "Whoops, couldn't find game #{id}"
      gameObj = _.merge game.opts,
        gameId: game.id
        user:
          name: window.user.name
          id: window.user._id

      # If the game is removed from FireBase, redirect user to lobby
      show Game, "Game", gameObj
    error: (xhr, errType, err) ->
      return show Status404, "404", msg: "Whoops, couldn't find game #{id}"

page.start()

module.exports = page
