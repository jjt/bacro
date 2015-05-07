router = require '../router'
GamelistItem = require './gamelistItem'
R = React.DOM

module.exports = React.createClass
  displayName: 'Gamelist'

  render: ()->
    # Sort by gameState - "new" comes before "started", which is what we want
    games = _.chain(@props.gamelist)
      .sortBy (game) -> game.gameState
      .map (game) =>
        state = game.gameState
        id = game.id
        key = "game-#{id}"
        playersStr = if game.numPlayers == 0 then "no players" else "#{game.numPlayers} players"
        if game.numPlayers == 1
          playersStr = '1 player'
        if state == 'new'
          buttonText = 'Join'
          body = "JOIN GAME - #{playersStr}"
        if state == 'started'
          buttonText = 'Watch'
          body = "WATCH GAME - Round #{game.roundNum+1}/#{game.numRounds}"

        gameProps = {state, buttonText, body, id, key}
        <GamelistItem {...gameProps}/>
      .value()

    <div className='Gamelist'>
      {games}
    </div>
