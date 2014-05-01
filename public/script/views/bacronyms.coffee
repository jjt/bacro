R = React.DOM
module.exports = React.createClass
  render: ->
    R.div className: 'Bacronyms', _.map @props.bacronyms, (bacronymObj, user)=>
      R.p {}, 'Bacronym goes here'
