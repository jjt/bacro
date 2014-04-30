fb = require '../../lib/firebase'
Game = require '../../lib/game'

log = ()-> console.log.apply null, arguments

module.exports = (app)->
  Games =
    lobby: (req, res) ->
      res.render 'game/index',
        user: req.user

    game: (req, res) ->
      res.send 200, 'game OK'

    new: (req, res) ->
      game = new Game()
      game.bind 'round:start', log
      game.bind 'answer:start', log
      game.bind 'answer:end', log
      game.bind 'vote:start', log
      game.bind 'vote:end', log
      game.bind 'round:end', log
      game.bind 'game:end', log
      game.nextRound()
      app.set('games', app.get('games').slice().push(game))
      res.send 200, game.id

    chat: (req, res)->
      console.log req.user
      channel = req.body.channel
      msg = req.body.msg
      user = req.user.name
      time = (new Date).getTime()

      if not channel or not msg
        return res.send 404

      fb.child("chats/#{channel}").push {user, msg, time}
      res.send 200

    answer: (req, res)->
      res.send 200, 'answer OK'


  return Games

