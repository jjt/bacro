define(['socketio'], function(io) {
  var sock;
  sock = io.connect('http://bacro.node');
  sock.on('connection', function(socket) {
    console.log('conanorsentaonection');
    return socket.emit('news', {
      hello: 'arstarst'
    });
  });
  return function() {
    return sock;
  };
});
