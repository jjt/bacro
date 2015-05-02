module.exports = React.createClass
  displayName: 'GamelistItem'

  render: ()->
    <a
      data-state={@props.state}
      key={"game-#{@props.id}"}
      href={"/game/#{@props.id}"}
      className="Gamelist-game"
    >
      <span className="Gamelist-game-state btn">{@props.buttonText}</span>
      <span className="Gamelist-game-body">{@props.body}</span>
    </a>
