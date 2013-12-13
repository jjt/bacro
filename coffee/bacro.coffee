define [
  'ko'
  'socketio'
  './modules/game/gameViewModel'
  './modules/players/playersViewModel'
  './modules/lobby/lobbyViewModel'
],
(ko, io, GameViewModel, PlayersViewModel, LobbyViewModel) ->
  # Zepto/jQ return a special object with a naked $('#id') call,
  # .get(0) returns the actual HTML element
  $game = $('#Game').get(0)
  $players = $('#Players').get(0)
  $lobby = $('#Lobby').get(0)

  Bacro = {}

  Bacro.init = () ->
    console.log $game, $players, $lobby
    @gameVM = new GameViewModel
    @playersVM = new PlayersViewModel
    @lobbyVM = new LobbyViewModel
    if $game? then ko.applyBindings @gameVM, $game
    if $players? then ko.applyBindings @playersVM, $players
    if $lobby? then ko.applyBindings @lobbyVM, $lobby
  
    #sock = io.connect('http://bacro.node/')
    #sock.on 'news', (data) ->
      #console.log data
    #sock.emit 'custoevent', 'HOLLA'


  Bacro
