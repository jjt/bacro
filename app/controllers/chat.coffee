fb = require '../../lib/firebase'

module.exports =
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
    
