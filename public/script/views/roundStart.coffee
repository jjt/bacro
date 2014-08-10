R = React.DOM
module.exports = React.createClass
  displayName: 'RoundStart'
  render: ()->
    R.div {}, [
      R.h3 {}, "You'll have #{@props.time} seconds"
      R.p className: 'lead', "Ready?"
    ]

