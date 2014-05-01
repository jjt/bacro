UserList = require './userList'
Chat = require './chat'
R = React.DOM
module.exports = React.createClass
  render: ->
    users = require '../../../lib/names'
    R.div {className: 'Lobby'}, [
      R.div {className: 'row'}, [
        R.div {className: 'Lobby-games col-md-8'}, [
          R.a {className: 'btn btn-primary pull-right', href: '#/new'}, 'New Game'
          R.h2 {}, "Games"
          R.div {}, "Game"
          R.div {}, "Game"
          R.div {}, "Game"
          R.div {}, "Game"
          R.div {}, "Game"
        ]
        
        R.div {className: 'col-md-4'}, UserList {users}

      ]

      Chat
        channel: 'lobby'
    ]
