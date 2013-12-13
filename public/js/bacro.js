define(['ko', 'socketio', './modules/game/gameViewModel', './modules/players/playersViewModel', './modules/lobby/lobbyViewModel'], function(ko, io, GameViewModel, PlayersViewModel, LobbyViewModel) {
  var $game, $lobby, $players, Bacro;
  $game = $('#Game').get(0);
  $players = $('#Players').get(0);
  $lobby = $('#Lobby').get(0);
  Bacro = {};
  Bacro.init = function() {
    console.log($game, $players, $lobby);
    this.gameVM = new GameViewModel;
    this.playersVM = new PlayersViewModel;
    this.lobbyVM = new LobbyViewModel;
    if ($game != null) {
      ko.applyBindings(this.gameVM, $game);
    }
    if ($players != null) {
      ko.applyBindings(this.playersVM, $players);
    }
    if ($lobby != null) {
      return ko.applyBindings(this.lobbyVM, $lobby);
    }
  };
  return Bacro;
});
