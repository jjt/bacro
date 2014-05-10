randStr = require('./randStr')
states = require('./gameStates')
fb = require('./firebase')
_ = require('lodash')
salt = require('./salt')
md5 = require 'MD5'
randomWords = require 'random-words'

MicroEvent = require('microevent')
GameModel = require '../app/models/game'

acronym = (len = 3) ->
  ret = ''
  while len--
    ret += String.fromCharCode _.random 65, 90
  ret

now = ()-> (new Date).getTime()
nowISO = ()-> (new Date).toISOString()

ucFirst = (str)->
  str.slice(0,1).toUpperCase() + str.slice(1)


class Game

  constructor: (model)->
    if not model?
      model = new GameModel
      model.save()

    @model = model
    @id = @model.id.toString()

    @timeouts = []
    
    @fbRef = fb.child "games/#{@id}"
      

    @bindEvents
      'game:start': @persistGameLocal
      'round:start': @persistGame
      'answer:start': @persistGameLocal
      'answer:end': @persistGameLocal
      'vote:start': @persistGame
      'vote:end': @persistGame
      'round:end': @persistGameLocal
      'game:end': @persistGameLocal
      'vote': @persistGameLocal
      'bacronym': @persistGameLocal
      'players:added': @persistGame

      
  addPlayers: (players)->
    if not _.isArray players
      players = [players]
    players.forEach (player)=>
      @initScore player
    @model.data.players = @model.data.players.concat players
    @trigger 'players:added', 'players:added', players

  bindEvents: (obj)->
    _.forEach obj, (fn, trigger)=>
      @bind trigger, fn.bind this, trigger


  clearTO: ()->
    clearTimeout timeout for timeout in @timeouts
    @timeouts = []
  
  setTO: (fn, delay)->
    @timeouts.push setTimeout fn.bind(this), delay

  currentRound: ()->
    @model.data.rounds[@model.data.roundNum]

  persistGame: (trigger)->
    @persistGameLocal()
    @persistGameToFirebase trigger

  persistGameLocal: ()->
    @model.save (err, model)=>
      if err?
        console.log 'persistGameLocal  ERR', err, model

  persistGameToFirebase: (trigger)->
    @fbRef.set @getRedacted trigger

  # Firebase games are public knowledge, so we have to withold some secrets
  # It's for the good of the BACROuntry
  getRedacted: (trigger)->
    game = (@model.toObject()).data
    game.scores = _.reduce game.scores, (accum, score, userId)->
      user = _.find(game.players, id: userId)
      accum[user.name] = score
      accum
    ,
    {}
        
    # For start of voting, replace user names with hashes
    if trigger == 'vote:start'
      round = game.rounds[@model.data.roundNum]
      anonUsers = _.keys(round.bacronyms).map (el)->
        md5(el + salt + round.roundNum).slice 0,8
      bacronyms = _.values round.bacronyms
      bacronymsObj = _.zipObject anonUsers, bacronyms
      round.bacronyms = bacronymsObj
      # We sholudn't have any votes here, but just in case we do...
      delete game.rounds[@model.data.roundNum].votes
      game.rounds[@model.data.roundNum] = round

    game

  startGame: ()->
    @model.data.gameState = 'started'
    @setScores()
    @nextRound()

  nextRound: ()->
    @clearTO()
    @model.data.roundNum = @model.data.rounds.length

    if @model.data.roundNum == @model.opts.numRounds
      return @endGame()

    if @model.data.roundNum == 0
      @trigger 'game:start', 'game:start'


    @model.data.rounds.push
      acronym: acronym _.random(3,6)
      bacronyms: {}
      phase: 'start'
      started: nowISO()
      roundNum: @model.data.roundNum
      votes: {}

    @trigger "round:start", "round:start", @model.data.roundNum
    @persistGameToFirebase
    @setTO @startAnswer, @model.opts.bufferTime

  startAnswer: ()->
    @clearTO()
    @currentRound().phase = 'answer'
    @trigger "answer:start", "answer:start", @model.data.roundNum
    @model.data.players.forEach (user)=>
      words = randomWords(@currentRound().acronym.length)
      @submitBacronym words.map(ucFirst).join(' '), user
    @setTO @endAnswer, @model.opts.answerTime

  endAnswer: ()->
    @clearTO()
    @trigger "answer:end", "answer:end", @model.data.roundNum
    @setTO @startVote, @model.opts.bufferTime

  startVote: ()->
    @clearTO()
    @currentRound().phase = 'vote'
    @model.data.players.forEach (user)=>
      @submitVote (_.sample(@model.data.players)).id, user.id
    @trigger "vote:start", "vote:start", @model.data.roundNum
    @setTO @endVote, @model.opts.voteTime

  endVote: ()->
    @clearTO()
    @currentRound().phase = 'end'
    @setVotesOnBacronyms()
    @setScores()
    @trigger "vote:end", "vote:end", @model.data.roundNum
    @setTO @endRound, @model.opts.voteEndTime

  endRound: ()->
    @clearTO()
    @trigger 'round:end', 'round:end', @model.data.roundNum
    @nextRound()

  endGame: ()->
    @model.data.gameState
    @trigger 'game:end', 'game:end'

  # {user, answer, timestamp}
  submitBacronym: (bacronym, user, time = nowISO(), votes = [])->
    @currentRound().bacronyms[user.id] = {bacronym, time, votes}
    @trigger 'bacronym', {user, bacronym, time, votes}

  submitVote: (candidate, voter) ->
    @currentRound().votes[voter] = candidate
    @trigger 'vote', {candidate, voter}
    

  initScore: (player)->
    @model.data.scores[player.id] = 0

  getFreshScoreObj: ()->

  setVotesOnBacronyms: ()->
    round = @currentRound()
    voteCounts = _.countBy round.votes
    voteCountsKeys = _.keys voteCounts
    round.bacronyms = _.reduce round.bacronyms, (accum, obj, user)->
      votes = 0
      if user in voteCountsKeys
        votes = voteCounts[user]
      obj.votes = votes
      accum[user] = obj
      accum
    , {}
     
  # Recalculates scores
  setScores: ()->
    scores = {}
    for player in @model.data.players
      if not scores[player.id]?
        scores[player.id] = 0
    for round in @model.data.rounds
      for voter, candidate of round.votes
        if not scores[candidate]?
          scores[candidate] = 0
        scores[candidate]++
    @model.data.scores = scores

MicroEvent.mixin Game



     

module.exports = Game
