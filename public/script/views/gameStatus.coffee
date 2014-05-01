UserList = require './userList'
R = React.DOM

module.exports = React.createClass
  render: ->
    R.div {className:'GameStatus'},
      UserList users: @props.game.scores
