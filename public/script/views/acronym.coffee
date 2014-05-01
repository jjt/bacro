R = React.DOM
module.exports = React.createClass
  render: ->
    R.div className:'Acronym', [
      R.div className:'container', [
        R.div className:'row', [
          R.p className:'Acronym-acronym', @props.acronym
        ]
      ]
    ]
