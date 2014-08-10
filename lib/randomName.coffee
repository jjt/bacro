names = require('./names')
adjectives = require('./adjectives')
nouns = require('./nouns')
_ = require 'lodash'

randomName = ()->
  shortAdjectives = adjectives.filter (adjective)-> 2 < adjective.length < 7
  shortNouns = nouns.filter (noun)-> 2 < noun.length < 7
  "#{_.sample(shortAdjectives)} #{_.sample(shortNouns, 2).join(' ')}"

module.exports = randomName
