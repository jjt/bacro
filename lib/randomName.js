var adjectives, names, nouns, randomName, _;

names = require('./names');

adjectives = require('./adjectives');

nouns = require('./nouns');

_ = require('lodash');

randomName = function() {
  var shortAdjectives, shortNouns;
  shortAdjectives = adjectives.filter(function(adjective) {
    var _ref;
    return (2 < (_ref = adjective.length) && _ref < 7);
  });
  shortNouns = nouns.filter(function(noun) {
    var _ref;
    return (2 < (_ref = noun.length) && _ref < 7);
  });
  return "" + (_.sample(shortAdjectives)) + " " + (_.sample(shortNouns, 2).join(' '));
};

module.exports = randomName;
