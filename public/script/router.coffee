Game = require './views/game'
Lobby = require './views/lobby'
Status404 = require './views/404'
Header = require './views/header'
page = require ('../bower_components/page.js/index')
csrfPost = require('../../lib/csrfPost')
fb = require('./fbRoot')

show = (component, title, props={})->
  console.log props
  $header = document.getElementById('site-nav')
  $app = document.getElementById('app')
  headerObj =
    breadCrumbs: [title]
    username:user.name
    page: page

  React.renderComponent Header(headerObj), $header
  React.renderComponent component(props), $app

page '/', show.bind null, Lobby, 'Lobby'
page '/lobby', show.bind null, Lobby, 'Lobby'
page '/game/new', (ctx)->
  console.log 'gamenew'
  respFn = (gameId)->
    console.log 'gamenew', gameId
    page.replace "/game/#{gameId}"
  failFn = ()->
    console.log arguments

  csrfPost '/game/new', newGame:'Yeah newGame!' , respFn, failFn
  
  

page '/game/:id', (ctx)->
  id = ctx.params.id
  console.log 'ctx.params', ctx.params.id
  $.ajax
    url: "/game/get/#{id}"
    success: (game)->
      console.log 'got game', game
      if not game?
        return show Status404, "404", msg: "Whoops, couldn't find game #{id}"
      gameObj = _.merge game.opts,
        gameId: game.id
        
      show Game, "Game #{game.id}", gameObj
    error: (xhr, errType, err) ->
      return show Status404, "404", msg: "Whoops, couldn't find game #{id}"

page.start()

module.exports = page
