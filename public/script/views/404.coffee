R = React.DOM
module.exports = React.createClass
  displayName: '404'
  render: ()->
    R.div className:'container', [
      R.div className:'row', [
        R.div className:'col-xs-12', [
          R.div {className: '404'}, [
            R.h1 {}, "AIN'T BE FOUND (404)"
            R.p {className: 'lead'}, @props.msg
          ]
        ]
      ]
    ]
