R = React.DOM

module.exports = React.createClass
  render: ()->
    users = _(@props.users)
      .sortBy 'name'
      .tap console.log.bind console
      .map (obj)->
        R.div {className: 'UserList-item', key:obj.name}, obj.name
      .value()

      # Scoreboard object {user: score}
    
    R.div {className:'UserList'}, [
      R.div {className:'UserList-list'}, users
    ]
