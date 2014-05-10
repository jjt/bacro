R = React.DOM
module.exports = React.createClass
  displayName: 'GameStart'
  render: ()->
    R.div className:'GameStart', [
      R.a onClick: @props.handleJoin, "Join game"
      R.a onClick: @props.handleGameStart, "Start game"
      R.p {}, "Player list goes here!"
    ]
