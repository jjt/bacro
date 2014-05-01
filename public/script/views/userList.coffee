R = React.DOM

module.exports = React.createClass
  render: ()->
    users = ()=>
      # Flat array
      if _.isArray @props.users
        return @props.users.sort().map (user)->
          R.li {key:user}, user
      # Scoreboard object {user: score}
      _.map @props.users, (score, user)->
        R.li {key:user}, [
          R.span className:'UserList-user', user
          R.span className:'UserList-score', score
        ]
    
    R.div {className:'UserList'}, [
      R.ul {className:'UserList-list list-unstyled'}, users()
    ]
    # Flat list of user names

