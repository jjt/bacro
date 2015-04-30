R = React.DOM
module.exports = React.createClass
  displayName: 'RoundStart'
  render: ()->
    <div>
      <h3>You'll have {@props.time} seconds</h3>
      <p className='lead'>Ready?</p>
    </div>

