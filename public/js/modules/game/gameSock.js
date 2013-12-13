define(['socketio'], function(io) {
  return function(game) {
    var socket;
    socket = io.connect("http://bacro.node/game/" + game.id);
    return socket.on('connect', function() {
      return console.log("Welcome to " + game.id);
    });
  };
});
