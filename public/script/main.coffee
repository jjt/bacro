# require 'director'
router = require './router'







#page dispatch: true
#page '', show.bind null, Lobby, 'Lobby'



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
