R = React.DOM
module.exports = React.createClass
  displayName: 'GameStart'
  render: ()->
    joinBtn = ''
    if not @props.userJoined?
      joinBtn = (
        <a className='btn btn-primary' onClick={@props.handleJoin}>
          Join game
        </a>
      )

    startBtn = (
      <a className='btn btn-primary' onClick={@props.handleGameStart}>
        Start game
      </a>
    )

    <div className='GameStart'>
      {joinBtn}
      {startBtn}
    </div>
