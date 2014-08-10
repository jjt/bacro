tabletojson = require('tabletojson')
cheerio = require('cheerio')
fs = require 'fs'
_ = require 'lodash'

log = ()-> console.log arguments

sort = (arr)->
  console.log 'sort'
  arr.sort (a,b)-> a.length - b.length

doIt = ()->
  tabletojson
  fs.readFile 'wordlist.html', 'utf8', (err, data)->
    if err
      console.log "ERR"
      throw err

    $ = cheerio.load data

    words = []
    $('tr').each ()->
      texts = []
      $(this).children().each ()->
        texts.push $(this).text()
      words.push texts

    words = _(words)
      .filter 2:'n'
      .map (el)-> el[1]
      .tap sort
      .value()
    json = JSON.stringify words, null, 2
    fs.writeFile 'lib/nouns.js', json
doIt()
