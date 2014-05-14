Acronym = require './acronym'
Bacronyms = require './bacronyms'
BacronymForm = require('./bacronymForm')
Badge = require './badge'
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


getTimerBgClass = (ms)->
  if ms
    sec = ms/1000
    return "TimerBg-#{sec}s"
  ""

# Keeps the main react component leaner
InitFirebaseMixin =
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
        timerBgClass: getTimerBgClass @props.startTime
        userBacronym: null

      @firebaseOn "rounds/#{round.roundNum}/phase", 'value', (snapshot)=>
        console.log "FB on round phase", snapshot.val()
        @setState
          roundPhase: snapshot.val()
          roundFoot: snapshot.val()
          timerBgClass: getTimerBgClass @props[snapshot.val() + 'Time']

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
          timerBgClass: getTimerBgClass @props.voteTime

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

  mixins: [FirebaseMixin, InitFirebaseMixin]

  displayName: 'Game'

  componentWillMount: ()->
    @initGame()

  componentWillReceiveProps: (nextProps)->
    if nextProps?.gameId != @props.gameId
      @initGame(nextProps)

    
  getInitialState: ()->
    view: 'loading'
    round: null
    userBacronym: null
    roundHead: 'Brand new'
    roundMain: 'GAME'
    roundFoot: 'Do it to it'
    timerBgClass: ''
    

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
    timerBgClass = @state.timerBgClass
    
    if roundPhase == 'answer'
      timerBgClass += ' TimerBg-start'
      
    console.log 'roundPhase', roundPhase

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
        key: "BacronymForm-round-#{@state.roundNum}"
      console.log 'state.userbacronym', @state.userBacronym
      if @state.userBacronym?
        bForm.userBacronym = @state.userBacronym

      BacronymForm bForm
      
    if round?
      roundClass = "Game-round-#{round.roundNum + 1}"

    R.div {className: "Panel-body container Game #{roundClass}"},
      R.div className:'row Panel-fh-row', [
        R.div className:'Panel-left col-sm-4 col-lg-2', [
          Badge
            timerBgClass: timerBgClass
            head: @state.roundHead
            main: @state.roundMain
            foot: @state.roundFoot
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

module.exports = Game
