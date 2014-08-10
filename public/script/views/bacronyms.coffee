R = React.DOM
module.exports = React.createClass
  displayName: 'Bacronyms'
  render: ->
    R.ul className: 'Bacronyms list-unstyled', _.map @props.bacronyms, (bacronymObj, user)=>
      bacroObj =
        className: "Bacronym"
        onClick: (e)=>
          @props.handleBacronymVote user

      if bacronymObj.selected
        bacroObj.className += ' selected'

      R.li {}, [
        R.div bacroObj, [
          R.div className: 'checkHolder', [
            R.i className: if bacronymObj.selected then 'icon-ok' else 'icon-ok'
          ]
          R.span {}, bacronymObj.bacronym
        ]
      ]
