define [
  'ko'
  'socketio'
  './modules/game/gameViewModel'
  './modules/chat/chatViewModel'
  './modules/players/playersViewModel'
],
(ko, io, GameViewModel, ChatViewModel, PlayersViewModel) ->
  # Zepto/jQ return a special object with a naked $('#id') call,
  # .get(0) returns the actual HTML element
  $game = $('#Game').get(0)
  $chat = $('#Chat').get(0)
  $players = $('#Players').get(0)

  Bacro = {}

  Bacro.init = () ->
    @gameVM = new GameViewModel
    @chatVM = new ChatViewModel
    @playersVM = new PlayersViewModel
    ko.applyBindings @gameVM, $game
    ko.applyBindings @chatVM, $chat
    ko.applyBindings @playersVM, $players

    this

  sock = io.connect 'http://bacro.node'
  sock.on 'news', (data) ->
    console.log data
    sock.emit 'custoevent', data: 'YEAH'
  
  Bacro.sock = sock

  Bacro
