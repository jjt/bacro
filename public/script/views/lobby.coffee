UserList = require './userList'
Chat = require './chat'
R = React.DOM
module.exports = React.createClass
  render: ->
    users = require '../../../lib/names'
    R.div className: 'Lobby container', [
      R.div {className: 'row'}, [
        R.div {className: 'Lobby-games col-xs-12'}, [
          R.h2 {}, "Games"
          R.div {}, "Game"
          R.div {}, "Game"
          R.div {}, "Game"
          R.div {}, "Game"
          R.div {}, "Game"
        ]
      ]


      R.div className: 'row', [
        R.div className: 'col-lg-2 col-md-3', UserList {users}
        R.div className: 'col-lg-10 col-md-9', Chat channel: 'lobby'
      ]
    ]
