router = require '../router'
R = React.DOM

module.exports = React.createClass
  render: ()->
    R.div className: 'Gamelist',
      R.a href: '/game/new', className: "Gamelist-game Gamelist-newgame", [
        R.h4 {}, "New game"
        R.p {}, "Start a new game!"
      ]
      _.map @props.gamelist, (game, id)=>
        R.a href: "/game/#{id}", className: "Gamelist-game", [
          R.h4 {}, id
          R.p {}, "Round #{game.roundNum+1}/#{game.numRounds}, with #{game.numPlayers} players"
        ]
