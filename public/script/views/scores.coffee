R = React.DOM
module.exports = React.createClass
  render: ->
    console.log @props.game.scores
    R.ul className: 'Scores', _.map @props.game.scores, (score, user)=>
      R.li key: user, className: 'clearfix', [
        R.span className: 'Scores-name', user
        R.span className: 'Scores-score', score
      ]
