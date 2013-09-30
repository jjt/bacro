var bower;

bower = function(str) {
  return "../bower_components/" + str;
};

require.config({
  paths: {
    ko: bower('knockout.js/knockout-2.3.0.debug'),
    zepto: bower('zepto/zepto'),
    socketio: bower('socket.io-client/dist/socket.io')
  },
  shim: {
    zepto: {
      exports: '$'
    }
  }
});

require(['ko', 'socketio', 'zepto', 'bacro'], function(ko, io, $, Bacro) {
  window.$ = $;
  window.ko = ko;
  window.io = io;
  Bacro.init();
  return window.Bacro = Bacro;
});
