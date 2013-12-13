define(['socketio'], function(io) {
  return function() {
    var socket;
    socket = io.connect("http://bacro.node/lobby");
    return socket;
  };
});
