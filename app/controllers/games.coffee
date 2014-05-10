fb = require '../../lib/firebase'
Game = require '../../lib/game'
names = require '../../lib/names'
Gamelist = require '../../lib/gamelist'
GameModel = require '../models/game'
randStr = require('../../lib/randStr')
getGameFromDB = require '../../lib/getGameFromDB'

_ = require 'lodash'

log = ()-> console.log.apply null, arguments
testUsers = _.sample names, 8


module.exports = (app)->
  Games =
    # Main entry point for auth'd users
    # Whole experience is a SPA now
    app: (req, res)->
      res.render 'game/index',
        user: req.user

    get: (req, res)->
      res.status(200).json
        id:req.game.id


    start: (req, res)->
      #game = new Game id: req.params.id
      req.game.startGame()
      res.status(200).json req.game.getRedacted()

    new: (req, res) ->
      game = new Game()
      setGamelist = ()->
        Gamelist.set game

      Gamelist.set game
      game.bind 'game:start', setGamelist
      game.bind 'round:start', setGamelist
      game.bind 'game:end', setGamelist
      #game.bind 'round:start', log
      #game.bind 'answer:start', log
      #game.bind 'answer:end', log
      #game.bind 'vote:start', log
      #game.bind 'vote:end', log
      #game.bind 'round:end', log
      #game.bind 'game:end', log
      game.addPlayers _.map testUsers, (user)=>
        name: user
        id: randStr()
      #game.startGame()
      app.games.push game

      console.log "games.new added game #{game.id} to list", req.games.length, _.pluck(req.games, 'id')
      #res.set 'Content-Type', 'text/plain'
      res.status(200).json game.id


    join: (req, res)->
      getGameFromDB null, req.param('id'), (err, game)->
        if err?
          return res.status(500).send 'Whoops, something went wrong'
        game.addPlayers
          name: req.user.name
          id: req.user.id
        res.status(200).json msg: 'Welcome to the game, friendo!'


    answer: (req, res)->
      res.send 200, 'answer OK'

    vote: (req, res)->
      res.send 200, 'vote OK'

  return Games

