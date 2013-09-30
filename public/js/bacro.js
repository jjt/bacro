define(['ko', 'socketio', './modules/game/gameViewModel', './modules/chat/chatViewModel', './modules/players/playersViewModel'], function(ko, io, GameViewModel, ChatViewModel, PlayersViewModel) {
  var $chat, $game, $players, Bacro, sock;
  $game = $('#Game').get(0);
  $chat = $('#Chat').get(0);
  $players = $('#Players').get(0);
  Bacro = {};
  Bacro.init = function() {
    this.gameVM = new GameViewModel;
    this.chatVM = new ChatViewModel;
    this.playersVM = new PlayersViewModel;
    ko.applyBindings(this.gameVM, $game);
    ko.applyBindings(this.chatVM, $chat);
    ko.applyBindings(this.playersVM, $players);
    return this;
  };
  sock = io.connect('http://bacro.node');
  sock.on('news', function(data) {
    console.log(data);
    return sock.emit('custoevent', {
      data: 'YEAH'
    });
  });
  Bacro.sock = sock;
  return Bacro;
});
