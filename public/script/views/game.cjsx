Acronym = require './acronym.cjsx'
Bacronyms = require './bacronyms.cjsx'
BacronymForm = require './bacronymForm.cjsx'
Badge = require './badge.cjsx'
Chat = require './chat.cjsx'
GameStart = require './gameStart.cjsx'
RoundStart = require './roundStart.cjsx'
ScoreBoard = require './scoreBoard.cjsx'
Status404 = require './404.cjsx'

FirebaseMixin = require '../firebaseMixin'


#fbRoot = require '../fbRoot'
#validateBacronym = require '../../../lib/validateBacronym'
csrfPost = require('../../../lib/csrfPost')

R = React.DOM
#cx = React.addons.classSet


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
        roundFoot: 'ready'
        roundMain: round.acronym
        userBacronym: null

      @firebaseOn "rounds/#{round.roundNum}/phase", 'value', (snapshot)=>
        roundPhase = snapshot.val()
        # Redir user to lobby if the game gets taken offline
        # Might be a better place for this, like the router
        # but I don't want to incur extra trips to Firebase
        if not roundPhase?
          console.log 'NO PHASE, GAME IS DEAD'
          @firebaseDestroy()
          page '/lobby'
          return

        roundFoot = roundPhase

        time = @props[snapshot.val() + 'Time']
        if roundPhase == 'answer'
          time = round.time
        timerBgClass = getTimerBgClass time

        if roundPhase == 'start'
          roundFoot = 'ready'

        @setState {roundPhase, roundFoot, timerBgClass}

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
    csrfPost "/game/vote",
      id: @props.gameId
      bacronym: bacronyms[user].bacronym
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


    mainComponent = ()=>
      if roundPhase == 'start'
        return <RoundStart time={round.time / 1000} />

      if not round?
        return <GameStart handleGameStart={@handleGameStart} handleJoin={@handleJoin} />

      if roundPhase == 'vote' or roundPhase == 'end'
        return (
          <Bacronyms
            bacronyms={round.bacronyms}
            handleBacronymVote={@handleBacronymVote}
          />
        )

      bForm =
        submitBacronym: @submitBacronym
        key: "BacronymForm-round-#{@state.roundNum}"
      if @state.userBacronym?
        bForm.userBacronym = @state.userBacronym

      <BacronymForm {...bForm} />

    roundClass = ''
    if round?
      roundClass = "Game-round-#{round.roundNum + 1}"

    <div className={"Panel-body container Game #{roundClass}"}>
      <div className='row Panel-fh-row'>
        <div className='Panel-left col-sm-4 col-lg-3'>
          <Badge
            timerBgClass={timerBgClass}
            head={@state.roundHead}
            main={@state.roundMain}
            foot={@state.roundFoot}
          />
          <ScoreBoard scores={@state.scores} />
        </div>
        <div className='Panel-main col-sm-8 col-lg-5'>
          <div className='Game-MainComponent'>
            {mainComponent()}
          </div>
        </div>
        <div className='Panel-right col-md-12 col-lg-4'>
          <Chat channel="#{@props.gameId}" />
        </div>
      </div>
    </div>

module.exports = Game
