# require 'director'
Game = require './views/game'
Lobby = require './views/lobby'
Status404 = require './views/404'
Header = require './views/header'
page = require '../bower_components/page.js/index'


show = (component, title, props={})->
  #React.renderComponent Header(breadCrumbs: [title]), document.getElementById('nav')
  console.log 'show'
  React.renderComponent component(props), document.getElementById('app')




page dispatch: true
page '*', ()-> console.log 'star'
page '/', show.bind null, Lobby, 'Lobby'
page '/lobby', show.bind null, Lobby, 'Lobby'
page '/game/:id', show.bind null, Game, 'Game'


console.log page


#module.exports = new Router
  #'/lobby': ()->
    #show Lobby, 'Lobby'
  #'/new': ()->
    #$.get '/game/new', (resp)=>
      #@setRoute "/#{resp}"
  #'/:id': (id)->
    #show Game, "Game #{id}", gameId: id
    #return
    #require('./fbRoot').child("games/#{id}").once 'value', (snapshot)=>
      #if not snapshot.val()?
        #return show Status404, msg: "Whoops, looks like that game doesn't exist"
      #console.log 'firebase on value', snapshot.val()
      #show Game, "Game #{id}", game: snapshot.val()
    
