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
        players: req.game.model.data.players
        opts: req.game.model.opts
    
    clearFb: ()->
      fb.child('games').remove()

    start: (req, res)->
      #game = new Game id: req.params.id
      req.game.startGame()
      res.status(200).json req.game.getForFirebase()

    new: (req, res) ->
      game = new Game()
      game.addPlayers
        name: req.user.name
        id: req.user.id

      setGamelist = ()->
        console.log 'setGamelist'
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
      #game.addPlayers _.map testUsers, (user)=>
        #name: user
        #id: randStr()
      #game.startGame()
      app.games.push game

      console.log "games.new added game #{game.id} to list", req.games.length, _.pluck(req.games, 'id')
      #res.set 'Content-Type', 'text/plain'
      res.status(200).json game.id


    join: (req, res)->
      req.game.addPlayers
        name: req.user.name
        id: req.user.id
      Gamelist.set req.game
      res.status(200).json msg: 'Welcome to the game, friendo!'


    answer: (req, res)->
      req.game.submitBacronym req.param('bacronym'), req.user
      res.send 200, 'answer OK'

    vote: (req, res)->
      req.game.submitVote req.param('bacronym'), req.user
      res.send 200, 'vote OK'


  return Games

