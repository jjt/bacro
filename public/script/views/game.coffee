Acronym = require './acronym'
Bacronyms = require './bacronyms'
Chat = require './chat'
GameStatus = require './gameStatus'
ReactLifeCycle = require '../../../lib/reactLifeCycle'
Status404 = require './404'

FirebaseMixin = require '../firebaseMixin'


fbRoot = require '../fbRoot'
validateBacronym = require '../../../lib/validateBacronym'
csrfPost = require('../../../lib/csrfPost')

R = React.DOM
cx = React.addons.classSet



Game = React.createClass

  mixins: [FirebaseMixin]

  componentWillMount: ()->
    @initGame()

  componentWillReceiveProps: (nextProps)->
    console.log 'cWRP', nextProps
    if nextProps?.gameId != @props.gameId
      @initGame(nextProps)

  getInitialState: ()->
    view: 'loading'

  initGame: (props)->
    if not props?
      props = @props

    console.log 'initGame', props
      
    @firebaseInit "games/#{@props.gameId}", 'fb'

    @firebaseOnce null, 'value', (snapshot)=>
      game = snapshot.val()
      if not game?
        return @setState view: '404'
      @setState
        view: 'game'
        game: game

      console.log 'Firebase once', game

    @firebaseOn 'scores', 'value', (snapshot)=>
      console.log 'FB scores value', snapshot.val()
      @setState
        scores: snapshot.val()

    @firebaseRef('rounds').limit(1).on 'child_added', (snapshot)=>
      round = snapshot.val()
      console.log 'round child added', round
      @setState
        round: round

      @firebaseOn "rounds/#{round.roundNum}/bacronyms", 'value', (snapshot)=>
        bacronyms = snapshot.val()
        console.log 'bacronyms value', bacronyms
        @setState
          round:
            _.merge @state.round, {bacronyms}

      @firebaseOn "rounds/#{round.roundNum}/votes", 'value', (snapshot)=>
        votes = snapshot.val()
        console.log 'votes value', votes
        @setState
          round:
            _.merge @state.round, {votes}

    #state.fbRef.on 'child_changed', (snapshot)=>
      #console.log 'child_changed', snapshot.val()
    #state.fbRef.on 'child_added', (snapshot)=>
      #console.log 'child_added', snapshot.val()


  handleBacronymSubmit: (e)->
    e.preventDefault()
    $input = @refs.bacronymInput.getDOMNode()
    bacronym = $input.value
    # TODO: Bacronym validation
    $input.value = ''
    @setState userBacronym: bacronym
    csrfPost "/game/#{@props.game.id}/answer", {bacronym}
    false

  handleBacronymVote: ()->
    

  render: ->
    if not @state.game? or @state.view == 'loading'
      return R.div {}, 'Game loading'

    if @state.view == '404'
      return Status404 {}, msg: "Whoops, looks like that game doesn't exist"

    round = @state.round
  

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
      if round.bacronyms?
        return Bacronyms
          bacronyms: round.bacronyms
          handleBacronymVote: @handleBacronymVote

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
      R.div className: "Game-main Game-round-#{round.roundNum + 1}", [
        R.div className: 'container', [
          R.div className: 'row', [
            R.div className:'RoundBadge col-lg-2 col-md-3', [
              R.h3 className:'Game-round', "Round #{round.roundNum + 1}"
              R.p className: "Acronym-acronym acronym-len-#{round.acronym.length}", round.acronym
            ]
            R.div className: 'col-lg-10 col-md-9', mainComponent()
          ]
        ]
      ]

      R.div className: 'Game-lower container', [
        R.div className: 'row', [
          R.div className: 'col-lg-2 col-md-3', [
            GameStatus scores: @state.scores
          ]
          R.div className: 'col-lg-10 col-md-9', [
            Chat
              channel: "#{@props.gameId}"
          ]
        ]
      ]
        
    ]

module.exports = Game
