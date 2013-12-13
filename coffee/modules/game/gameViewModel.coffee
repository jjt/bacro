define [
  'ko'
  './gameModel'
  '../chat/chatViewModel'
],
(ko, gameModel, chatViewModel) ->
 
  gameId = window.location.href.split('/').pop()
  game = new gameModel id: gameId
  gameViewModel = () ->
    @acronym = ko.observable "RULRN"
    @bacronymInput = ko.observable ""
    @bacronymSubmit = (formEl) ->
      console.log 'bacronym submit'
    @game = game
    this

  socket = io.connect "http://bacro.node/game/#{game.id}"
  #socket = io.connect "http://bacro.node/game"
  socket.on 'connect', () ->
    console.log "Welcome to #{game.id}"

  socket.on 'chat', (msg) ->
    console.log msg
    $chat.prepend "#{msg}<br>"

  gameViewModel
