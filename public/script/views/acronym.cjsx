R = React.DOM
module.exports = React.createClass
  displayName: 'Acronym'
  render: ->
    <div className='Acronym'>
      <div className='container'>
        <div className='row'>
          <p className='Acronym-acronym'>{@props.acronym}</p>
        </div>
      </div>
    </div>
