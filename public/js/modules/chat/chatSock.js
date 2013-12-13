define(['socketio'], function(io) {
  return function(namespace) {
    var socket;
    socket = io.connect("http://bacro.node/chat/" + namespace);
    console.log("socket with namespace: " + namespace);
    console.log(io.sockets);
    window.onBeforeUnload = function() {
      return socket.disconnect();
    };
    return socket;
  };
});
