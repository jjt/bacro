UserList = require './userList.cjsx'
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

    scoreComponents = _.map scores, (obj)->
      <li key={obj.name} className='UserList-item'>
        <span className='UserList-user'>{obj.name}</span>
        <span className='UserList-score'>{obj.score}</span>
      </li>

    <div className='ScoreBoard'>
      <ul className='UserList-list'>
        {scoreComponents}
      </ul>
    </div>
