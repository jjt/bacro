router = require '../router'
R = React.DOM

module.exports = React.createClass
  displayName: 'Gamelist'
  render: ()->
    R.div className: 'Gamelist',
      R.a href: '/game/new', className: "Gamelist-game Gamelist-newgame", [
        R.h4 {}, "New game"
        R.p {}, "Start a new game"
      ]

      _.map @props.gamelist, (game, id)=>
        gameState = game.gameState
        body = if game.numPlayers == 0 then "no players" else "#{game.numPlayers} players"
        if game.numPlayers == 1
          body = "1 player"
        if gameState == 'new'
          gameState = "New Game"
          body += ' - join now'
        if gameState == 'started'
          body = "Round #{game.roundNum+1}/#{game.numRounds}, with #{body}"

        R.a key: "game-#{id}", href: "/game/#{id}", className: "Gamelist-game", [
          R.h4 {}, gameState
          R.p {}, body
        ]
