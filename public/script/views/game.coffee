Acronym = require './acronym'
Bacronyms = require './bacronyms'
Chat = require './chat'
GameStatus = require './gameStatus'
validateBacronym = require '../../../lib/validateBacronym'
csrfPost = require('../../../lib/csrfPost')
R = React.DOM
cx = React.addons.classSet

module.exports = React.createClass
  componentWillReceiveProps: (nextProps)->
    if nextProps.game?.rounds[nextProps.game.rounds.length-1].phase == 'vote'
      @setState @getInitialState()

  getInitialState: ()->
    userBacronym: null

  handleBacronymSubmit: (e)->
    e.preventDefault()
    $input = @refs.bacronymInput.getDOMNode()
    bacronym = $input.value
    # TODO: Bacronym validation
    $input.value = ''
    @setState userBacronym: bacronym
    csrfPost "/game/#{@props.game.id}/answer", {bacronym}
    false

  render: ->
    round = @props.game.rounds[@props.game.roundNum]

    if not @state?.userBacronym?
      userBacronym = R.p className: 'Game-userBacronym no-bacronym', [
        'Submit a bacronym '
        R.span className:'x-small', '▼'
      ]
      placeholder = "Type in a bacronym and hit enter"
    else
      userBacronym = R.p className: 'Game-userBacronym', @state.userBacronym
      placeholder = "Enter a new bacronym and hit enter (replaces old one)"

    mainComponent = ()=>
      if round.phase == 'vote'
        return Bacronyms bacronyms: round.bacronyms

      R.form className: 'Game-bacronym-form', onSubmit: @handleBacronymSubmit, [
        userBacronym
        R.div className: 'form-group',
          R.input
            className: 'Game-bacronymInput form-control input-lg'
            type:'text'
            ref: 'bacronymInput'
            placeholder: placeholder
      ]

    R.div {className: 'Game'}, [
      R.div className: "Game-main Game-round-#{@props.game.roundNum + 1}", [
        R.div className: 'container', [
          R.div className: 'row', [
            R.div className:'RoundBadge col-lg-2 col-md-3', [
              R.h2 className:'Game-round', "Round #{@props.game.roundNum + 1}"
              R.p className: "Acronym-acronym acronym-len-#{round.acronym.length}", round.acronym
            ]
            R.div className: 'col-lg-10 col-md-9', mainComponent()
          ]
        ]
      ]

      R.div className: 'Game-lower container', [
        R.div className: 'row', [
          R.div className: 'col-lg-2 col-md-3', [
            GameStatus game: @props.game
          ]
          R.div className: 'col-lg-10 col-md-9', [
            Chat
              channel: "#{@props.game.id}"
          ]
        ]
      ]
        
    ]
