R = React.DOM
module.exports = React.createClass
  render: ->
    R.ul className: 'Bacronyms list-unstyled', _.map @props.bacronyms, (bacronymObj, user)=>
      liObj =
        className: "Bacronym"
        onClick: @props.handleBacronymVote.bind null, user
      if bacronymObj.selected
        liObj.className += ' selected'

      R.li liObj, [
        R.div className: 'checkHolder', [
          R.i className: if bacronymObj.selected then 'icon-ok' else 'icon-ok'
        ]
        R.span {}, bacronymObj.bacronym
      ]
