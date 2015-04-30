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
    <div ref='RoundBadge' className={"RoundBadge #{@props.timerBgClass}"}>
      <h3 className='Game-round'>{@props.head}</h3>
      <p className={"Acronym-acronym #{lenClass}"}>{@props.main}</p>
      <p className="Game-phase">{@props.foot}</p>
    </div>
