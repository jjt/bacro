fb = require '../../lib/firebase'

randStr = (len=8)-> Math.random().toString(36).slice(2,len+2)

Games =
  lobby: (req, res) ->
    res.render 'game/index',
      user: req.user

  game: (req, res) ->
    res.send 200, 'game OK'

  new: (req, res) ->
    res.send 200, randStr()

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


exports = module.exports = Games
