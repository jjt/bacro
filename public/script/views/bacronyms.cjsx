R = React.DOM
module.exports = React.createClass
  displayName: 'Bacronyms'
  render: ->
    bacronyms = _.map @props.bacronyms, (bacronymObj, user)=>
      bacroObj =
        className: "Bacronym"
        onClick: (e)=>
          @props.handleBacronymVote user

      if bacronymObj.selected
        bacroObj.className += ' selected'

      <li>
        <div {...bacroObj}>
          <div className='checkHolder'>
            <i className={if bacronymObj.selected then 'icon-ok' else 'icon-ok'} />
          </div>
          <span>{bacronymObj.bacronym}</span>
        </div>
      </li>

    <ul className='Bacronyms list-unstyled'>{bacronyms}</ul>
