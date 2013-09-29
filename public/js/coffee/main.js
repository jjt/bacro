var bower;

bower = function(str) {
  return "../bower_components/" + str;
};

require.config({
  paths: {
    ko: bower('knockout.js/knockout-2.3.0.debug'),
    zepto: bower('zepto/zepto')
  },
  shim: {
    zepto: {
      exports: '$'
    }
  }
});

require(['ko', 'zepto', 'bacro'], function(ko, $, Bacro) {
  window.$ = $;
  window.ko = ko;
  Bacro.init();
  return window.Bacro = Bacro;
});
