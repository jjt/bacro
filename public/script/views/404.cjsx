R = React.DOM
module.exports = React.createClass
  displayName: '404'

  render: ()->
    <div className='container'>
      <div className='row'>
        <div className='col-xs-12'>
          <div className='404'>
            <h1>AIN'T BE FOUND (404)</h1>
            <p className='lead'>{@props.msg}</p>
          </div>
        </div>
      </div>
    </div>
