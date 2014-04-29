Firebase = require 'firebase'
fbConf = require('../config/firebase')

fb = new Firebase fbConf.url
fb.auth fbConf.secret

module.exports = fb
