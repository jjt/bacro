fb = require '../../lib/firebase'
Game = require '../../lib/game'
names = require '../../lib/names'
_ = require 'lodash'

log = ()-> console.log.apply null, arguments
testUsers = _.sample names, 8

module.exports = (app)->
  Games =
    lobby: (req, res) ->
      res.render 'game/index',
        user: req.user

    game: (req, res) ->
      res.send 200, 'game OK'

    new: (req, res) ->
      game = new Game()
      #game.bind 'round:start', log
      #game.bind 'answer:start', log
      #game.bind 'answer:end', log
      #game.bind 'vote:start', log
      #game.bind 'vote:end', log
      #game.bind 'round:end', log
      #game.bind 'game:end', log
      game.addPlayers testUsers
      game.startGame()
      #console.log app.games
      app.games.push game
      res.send 200, game.data.id


    answer: (req, res)->
      console.log 'game.answer', req.body.bacronym
      res.send 200, 'answer OK'


  return Games

