define(['ko', './gameModel', '../chat/chatViewModel'], function(ko, gameModel, chatViewModel) {
  var game, gameId, gameViewModel, socket;
  gameId = window.location.href.split('/').pop();
  game = new gameModel({
    id: gameId
  });
  gameViewModel = function() {
    this.acronym = ko.observable("RULRN");
    this.bacronymInput = ko.observable("");
    this.bacronymSubmit = function(formEl) {
      return console.log('bacronym submit');
    };
    this.game = game;
    return this;
  };
  socket = io.connect("http://bacro.node/game/" + game.id);
  socket.on('connect', function() {
    return console.log("Welcome to " + game.id);
  });
  socket.on('chat', function(msg) {
    console.log(msg);
    return $chat.prepend("" + msg + "<br>");
  });
  return gameViewModel;
});
