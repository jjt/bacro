R = React.DOM

module.exports = React.createClass
  displayName: 'UserList'
  render: ()->
    users = _(@props.users)
      .sortBy 'name'
      .map (obj)->
        R.div {className: 'UserList-item', key:obj.name}, obj.name
      .value()

    R.div {className:'UserList'}, [
      R.div {className:'UserList-list'}, users
    ]
