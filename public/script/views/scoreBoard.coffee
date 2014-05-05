UserList = require './userList'
R = React.DOM

module.exports = React.createClass
  render: ->
    console.log @props.scores
    scores = _(@props.scores)
      .map (score, name)->
        {name, score}
      .sortBy 'score'
      .reverse()
      .value()

    console.log scores
    R.div {className:'GameStatus'},
      R.ul className: 'UserList-list', 
        _.map scores, (obj)->
          R.li {key:obj.name, className: 'UserList-item'}, [
            R.span className:'UserList-user', obj.name
            R.span className:'UserList-score', obj.score
          ]