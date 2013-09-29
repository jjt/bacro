# Prepend the bower dir to a module
bower = (str) -> "../bower_components/#{str}"

require.config
  paths:
    ko: bower 'knockout.js/knockout-2.3.0.debug'
    zepto: bower 'zepto/zepto'
  shim:
    zepto:
      exports: '$'

require ['ko', 'zepto', 'bacro'], (ko, $, Bacro) ->
  window.$ = $
  window.ko = ko
  Bacro.init()
  window.Bacro = Bacro
