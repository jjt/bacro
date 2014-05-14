R = React.DOM
module.exports = React.createClass
  displayName: 'GameStart'
  render: ()->
    join = ''
    if not @props.userJoined?
      join = R.a className: 'btn btn-primary', onClick: @props.handleJoin, "Join game"
    R.div className:'GameStart', [
      join
      " "
      R.a className: 'btn btn-primary', onClick: @props.handleGameStart, "Start game"
    ]
