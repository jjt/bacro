var fb;

fb = require('../../lib/firebase');

module.exports = {
  chat: function(req, res) {
    var channel, msg, time, user;
    console.log(req.user);
    channel = req.body.channel;
    msg = req.body.msg;
    user = req.user.name;
    time = (new Date).getTime();
    if (!channel || !msg) {
      return res.send(404);
    }
    fb.child("chats/" + channel).push({
      user: user,
      msg: msg,
      time: time
    });
    return res.send(200);
  }
};
