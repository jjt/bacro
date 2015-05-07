module.exports = React.createClass
  displayName: 'GamelistItem'

  render: ()->
    iconClass = switch @props.state
      when 'new' then 'add-user'
      when 'started' then 'watch'
      else 'trophy'
    <a
      data-state={@props.state}
      key={"game-#{@props.id}"}
      href={"/game/#{@props.id}"}
      className="Gamelist-game"
    >
      <span className="icon-#{iconClass}"></span>
      <span className="Gamelist-game-body">{@props.body}</span>
    </a>
