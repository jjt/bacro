R = React.DOM
module.exports = React.createClass
  displayName: 'Badge'
  componentWillUpdate: ()->
    console.log 'componentWillUpdate'
    #$(@refs.RoundBadge.getDOMNode()).removeClass 'TimerBg-start'

  componentDidUpdate: ()->
    console.log 'componentDidUpdate'
    #$(@refs.RoundBadge.getDOMNode()).addClass 'TimerBg-start'

  render: ()->
    lenClass = "acronym-len-#{@props.main.length}"
    R.div ref: 'RoundBadge', className: "RoundBadge #{@props.timerBgClass}", [
      R.h3 className:'Game-round', @props.head
      R.p className: "Acronym-acronym #{lenClass}", @props.main
      R.p className: "Game-phase", @props.foot
    ]
