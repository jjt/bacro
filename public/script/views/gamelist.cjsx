router = require '../router'
R = React.DOM

module.exports = React.createClass
  displayName: 'Gamelist'

  render: ()->
    games = _.map @props.gamelist, (game, id)=>
      gameState = game.gameState
      body = if game.numPlayers == 0 then "no players" else "#{game.numPlayers} players"
      if game.numPlayers == 1
        body = "1 player"
      if gameState == 'new'
        gameState = "New Game"
        body += ' - join now'
      if gameState == 'started'
        body = "Round #{game.roundNum+1}/#{game.numRounds}, with #{body}"

      <a key={"game-#{id}"} href={"/game/#{id}"} className={"Gamelist-game"}>
        <h4>{gameState}</h4>
        <p>{body}</p>
      </a>

    <div className='Gamelist'>
      <a href='/game/new' className="Gamelist-game Gamelist-newgame">
        <h4>New game</h4>
        <p>Start a new game</p>
      </a>
      {games}
    </div>
