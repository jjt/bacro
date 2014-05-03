# require 'director'
Game = require './views/game'
Lobby = require './views/lobby'
Status404 = require './views/404'
Header = require './views/header'


show = (component, title, props={})->
  #React.renderComponent Header(breadCrumbs: [title]), document.getElementById('nav')
  React.renderComponent component(props), document.getElementById('app')

module.exports = new Router
  '/lobby': ()->
    show Lobby, 'Lobby'
  '/new': ()->
    $.get '/game/new', (resp)=>
      @setRoute "/#{resp}"
  '/:id': (id)->
    require('./fbRoot').child("games/#{id}").on 'value', (snapshot)=>
      if not snapshot.val()?
        return show Status404, msg: "Whoops, looks like that game doesn't exist"
      console.log 'firebase on value', snapshot.val()
      show Game, "Game #{id}", game: snapshot.val()
    
