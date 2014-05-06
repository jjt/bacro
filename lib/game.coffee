randStr = require('./randStr')
states = require('./gameStates')
fb = require('./firebase')
_ = require('lodash')
salt = require('./salt')
md5 = require 'MD5'
randomWords = require 'random-words'
MicroEvent = require('microevent')

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

  defaults: ()->
    numRounds: 8
    answerTime: 10000
    bufferTime: 2000
    voteTime: 10000

  constructor: (id = randStr(), optsIn = {})->
    @data =
      id: id
      rounds: []
      roundNum: 0
      gameState: 'new'
      scores: {}
      players: []

    @opts = _.merge @defaults(), optsIn
    @timeouts = []

    @persistEvents
      'round:start': @persistGame
      'vote:start': @persistGame
      'vote:end': @persistGame

    @fbRef = fb.child "games/#{@data.id}"
    
  addPlayers: (players)->
    if not _.isArray players
      players = [players]
    players.forEach (player)=>
      @initScore player
    @data.players = @data.players.concat players

  persistEvents: (obj)->
    _.forEach obj, (fn, trigger)=>
      @bind trigger, fn.bind this, trigger

  clearTO: ()->
    clearTimeout timeout for timeout in @timeouts
    @timeouts = []
  
  setTO: (fn, delay)->
    @timeouts.push setTimeout fn.bind(this), delay

  currentRound: ()->
    @data.rounds[@data.roundNum]

  persistGame: (trigger)->
    game = _.cloneDeep @data
    # For start of voting, replace user names with hashes
    if trigger == 'vote:start'
      round = game.rounds[@data.roundNum]
      anonUsers = _.keys(round.bacronyms).map (el)->
        md5(el + salt + round.roundNum).slice 0,8
      bacronyms = _.values round.bacronyms
      bacronymsObj = _.zipObject anonUsers, bacronyms
      round.bacronyms = bacronymsObj
      # We sholudn't have any votes here, but just in case we do...
      delete game.rounds[@data.roundNum].votes
      game.rounds[@data.roundNum] = round

    if trigger == 'vote:end'
      @fbRef.child("rounds/#{@data.roundNum}/bacronyms").remove()

    @fbRef.set game

  startGame: ()->
    @data.gameState = 'started'
    @setScores()
    #@persistGame()
    @nextRound()

  nextRound: ()->
    @clearTO()
    @data.roundNum = @data.rounds.length

    if @data.roundNum == @opts.numRounds
      return @endGame()

    @data.rounds.push
      acronym: acronym _.random(3,6)
      bacronyms: {}
      phase: 'start'
      started: nowISO()
      roundNum: @data.roundNum
      votes: {}

    @trigger "round:start", "round:start", @data.roundNum
    #@persistGame()
    @setTO @startAnswer, @opts.bufferTime

  startAnswer: ()->
    @clearTO()
    @currentRound().phase = 'answer'
    @trigger "answer:start", "answer:start", @data.roundNum
    @data.players.forEach (user)=>
      words = randomWords(@currentRound().acronym.length)
      @submitBacronym words.map(ucFirst).join(' '), user
    @setTO @endAnswer, @opts.answerTime

  endAnswer: ()->
    @clearTO()
    @trigger "answer:end", "answer:end", @data.roundNum
    @setTO @startVote, @opts.bufferTime

  startVote: ()->
    @clearTO()
    @currentRound().phase = 'vote'
    @data.players.forEach (user)=>
      @submitVote _.sample(@data.players), user
    @trigger "vote:start", "vote:start", @data.roundNum
    @setTO @endVote, @opts.voteTime

  endVote: ()->
    @clearTO()
    @currentRound().phase = 'end'
    @setVotesOnBacronyms()
    @setScores()
    @trigger "vote:end", "vote:end", @data.roundNum
    #@persistGame()
    @setTO @endRound, @opts.bufferTime

  endRound: ()->
    @clearTO()
    @trigger 'round:end', 'round:end', @data.roundNum
    @nextRound()

  endGame: ()->
    @data.gameState
    @trigger 'game:end', 'game:end', @data.roundNum

  # {user, answer, timestamp}
  submitBacronym: (bacronym, user, time = nowISO(), votes = [])->
    @currentRound().bacronyms[user] = {bacronym, time, votes}
    @trigger 'bacronym', {user, bacronym, time, votes}

  submitVote: (candidate, voter) ->
    @currentRound().votes[voter] = candidate
    

  initScore: (player)->
    @data.scores[player] = 0

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
    for player in @data.players
      if not scores[player]?
        scores[player] = 0
    for round in @data.rounds
      for voter, candidate of round.votes
        if not scores[candidate]?
          scores[candidate] = 0
        scores[candidate]++
    @data.scores = scores

MicroEvent.mixin Game



     

module.exports = Game
