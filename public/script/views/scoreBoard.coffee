UserList = require './userList'
R = React.DOM

module.exports = React.createClass
  displayName: 'ScoreBoard'
  render: ->
    scores = _(@props.scores)
      .map (score, name)->
        {name, score}
      .sortBy 'score'
      .reverse()
      .value()

    R.div {className:'ScoreBoard'},
      R.ul className: 'UserList-list',
        _.map scores, (obj)->
          R.li {key:obj.name, className: 'UserList-item'}, [
            R.span className:'UserList-user', obj.name
            R.span className:'UserList-score', obj.score
          ]
