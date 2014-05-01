Acronym = require './acronym'
Bacronyms = require './bacronyms'
Chat = require './chat'
GameStatus = require './gameStatus'
validateBacronym = require '../../../lib/validateBacronym'
R = React.DOM

module.exports = React.createClass
  handleBacronymSubmit: ()->
    csrfPost "/game/#{@props.game.id}/answer",
      bacronym: @refs.bacronymInput.getDOMNode().value
    false

  render: ->
    round = @props.game.rounds[@props.game.roundNum]

    mainComponent = ()=>
      console.log round
      if round.phase == 'vote'
        return Bacronyms bacronyms: round.bacronyms
      R.form onsubmit: @handleBacronymSubmit,
        R.div className: 'form-group',
          R.input
            className: 'Game-bacronymInput form-control input-lg'
            type:'text'
            ref: 'bacronymInput'
            placeholder: 'Type in a bacronym and hit enter'

    console.log Acronym, GameStatus

    R.div {className: 'Game'}, [
      R.div className: "Game-main Game-round-#{@props.game.roundNum + 1}", [
        R.div className: 'container', [
          R.h3 className:'Game-round', "Round #{@props.game.roundNum + 1}"
          R.p className: 'Acronym-acronym', round.acronym
          R.div {}, mainComponent()
        ]
      ]

      R.div className: 'Game-lower container', [
        R.div className: 'row', [
          R.div className: 'col-sm-3', [
            GameStatus game: @props.game
          ]
          R.div className: 'col-sm-9', [
            Chat
              channel: "#{@props.game.id}"
          ]
        ]
      ]
        
    ]
