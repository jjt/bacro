Acronym = require './acronym'
Bacronyms = require './bacronyms'
BacronymForm = require('./bacronymForm')
Chat = require './chat'
ScoreBoard = require './scoreBoard'
Status404 = require './404'
GameStart = require './gameStart'

FirebaseMixin = require '../firebaseMixin'


fbRoot = require '../fbRoot'
validateBacronym = require '../../../lib/validateBacronym'
csrfPost = require('../../../lib/csrfPost')

R = React.DOM
cx = React.addons.classSet


InitGameMixin =
  initGame: (props)->
    if not props?
      props = @props
    
    @setState @getInitialState()
      
    # Get rid of any old Firebase refs
    @firebaseDestroy()

    @firebaseInit "games/#{props.gameId}", 'fb'
    #@firebaseOnce null, 'value', (snapshot)=>
      #if not game?
        #return @setState view: '404'


    @firebaseOn 'scores', 'value', (snapshot)=>
      @setState
        scores: snapshot.val()

    @firebaseRef('rounds').limit(1).on 'child_added', (snapshot)=>
      round = snapshot.val()
      @setState
        round: round
        roundHead: "Round #{round.roundNum + 1}"
        roundPhase: 'start'
        roundFoot: 'start'
        roundMain: round.acronym

      @firebaseOn "rounds/#{round.roundNum}/phase", 'value', (snapshot)=>
        @setState
          roundPhase: snapshot.val()
          roundFoot: snapshot.val()

      @firebaseOn "rounds/#{round.roundNum}/bacronyms", 'value', (snapshot)=>
        bacronyms = snapshot.val()
        return unless bacronyms?
        # Firebase shows old bacronyms as well as new
        if @state.roundPhase == 'end'
          bacronyms = _.filter bacronyms, (obj)->
            'votes' of obj
        @setState
          round:
            _.merge @state.round, {bacronyms}

      @firebaseOn "rounds/#{round.roundNum}/votes", 'value', (snapshot)=>
        votes = snapshot.val()
        return unless votes?
        @setState
          round:
            _.merge @state.round, {votes}


    @setState
      view: 'game'
      game: props.game
    #state.fbRef.on 'child_changed', (snapshot)=>
    #state.fbRef.on 'child_added', (snapshot)=>




Game = React.createClass

  mixins: [FirebaseMixin, InitGameMixin]

  displayName: 'Game'

  componentWillMount: ()->
    @initGame()

  componentWillReceiveProps: (nextProps)->
    console.log @props, nextProps
    if nextProps?.gameId != @props.gameId
      @initGame(nextProps)

  getInitialState: ()->
    view: 'loading'
    round: null
    userBacronym: null
    roundHead: 'Hey There'
    roundMain: 'BACRO'
    roundFoot: 'New Game'
    

  submitBacronym: (bacronym)->
    # TODO: Bacronym validation
    @setState userBacronym: bacronym
    postBody =
      bacronym: bacronym
      id: @props.gameId
    csrfPost "/game/answer", postBody
    false

  handleBacronymVote: (user)->
    bacronyms = _.reduce @state.round.bacronyms, (accum, bacronymObj, user)->
      delete bacronymObj.selected
      accum[user] = bacronymObj
      accum
    , {}
    bacronyms[user]?.selected = true
    @setState
      round:
        _.merge @state.round, {bacronyms}

  handleGameStart: ()->
    csrfPost "/game/start/", id: @props.gameId

  handleJoin: ()->
    csrfPost "/game/join/", id: @props.gameId

  render: ->
    #if not @state.game? or @state.view == 'loading'
      #return R.div {}, 'Game loading'

    #if @state.view == '404'
      #return Status404 {}, msg: "Whoops, looks like that game doesn't exist"

    round = @state.round
    roundPhase = @state.roundPhase


    mainComponent = ()=>
      if not round?
        return GameStart
          handleGameStart: @handleGameStart
          handleJoin: @handleJoin
          
      if roundPhase == 'vote' or roundPhase == 'end'
        return Bacronyms
          bacronyms: round.bacronyms
          handleBacronymVote: @handleBacronymVote
      
      bForm =
        submitBacronym: @submitBacronym
      if @state.userBacronym
        bForm.userBacronym = @state.userBacronym

      BacronymForm bForm
      
    acroLenClass = "acronym-len-5"
    if round?
      roundClass = "Game-round-#{round.roundNum + 1}"
      acroLenClass = "acronym-len-#{round.acronym.length}"

    R.div {className: "Panel-body container Game #{roundClass}"}, [
      R.div className:'row Panel-fh-row', [
        R.div className:'Panel-left col-sm-4 col-lg-2', [
          R.div className:'RoundBadge TimerBg-10s', [
            R.h3 className:'Game-round', @state.roundHead
            R.p className: "Acronym-acronym #{acroLenClass}", @state.roundMain
            R.p className: "Game-phase", @state.roundFoot
          ]
          ScoreBoard scores: @state.scores
        ]
        R.div className:'Panel-main col-sm-8 col-lg-6', [
          R.div className:'Game-MainComponent', [
            mainComponent()
          ]
        ]
        R.div className:'Panel-right col-md-12 col-lg-4', [
          Chat
            channel: "#{@props.gameId}"
        ]
      ]
    ]

module.exports = Game
