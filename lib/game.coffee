randStr = require('./randStr')
states = require('./gameStates')
fb = require('./firebase')
_ = require('lodash')
MicroEvent = require('microevent')

acronym = (len = 3) ->
  ret = ''
  while len--
    ret += String.fromCharCode _.random 65, 90
  ret

now = ()-> (new Date).getTime()
nowISO = ()-> (new Date).toISOString()


testUsers = ['Tuppy', 'Honoria', 'Bertram']

class Game
  constructor: (id = randStr(), optsIn = {})->
    defaults =
      id: id
      numRounds: 8
      answerTime: 1300
      bufferTime: 300
      voteTime: 1300
      timeouts: []

    @data =
      rounds: []
      roundNum: 0
      gameState: 'new'

    @opts = _.merge defaults, optsIn

    @fbRef = fb.child "games/#{@id}"
    
  clearTO: ()->
    clearTimeout timeout for timeout in @timeouts
    @timeouts = []
  
  setTO: (fn, delay)->
    @timeouts.push setTimeout fn.bind(this), delay

  currentRound: ()->
    @data.rounds[@data.roundNum]

  persistGame: ()->
    @fbRef.child("games/#{@id}").set @data

  persistRoundNum: (roundNum = @data.roundNum)->
    @fbRef.child("roundNum").set roundNum

  persistScores: (scores = @getScores(), roundNum = @data.roundNum)->
    @fbRef.child("scores").set scores

  persistVotes: (roundNum = @data.roundNum)->
    @fbRef.child("rounds/#{roundNum}/votes").set @currentRound().votes

  persistRound: (round = @currentRound())->
    fb.child("games/#{@id}/rounds/#{round.roundNum}").set round

  persistBacronyms: (bacronyms = @currentRound().bacronyms, roundNum = @data.roundNum) ->
    fb.child("games/#{@id}/rounds/#{roundNum}/bacronyms/").set bacronyms

  startGame: ()->
    @data.gameState = 'started'
    @persistGame()
    return
    @nextRound()

  nextRound: ()->
    @clearTO()
    @data.roundNum = @data.rounds.length

    if @data.roundNum == @numRounds
      return @endGame()

    @data.rounds.push
      acronym: acronym _.random(3,6)
      bacronyms: {}
      phase: states.START
      started: nowISO()
      roundNum: @data.roundNum
      votes: {}

    @persistRoundNum()

    @trigger "round:start", "round:start", @data.roundNum
    @persistRound @currentRound()
    @setTO @startAnswer, @bufferTime

  startAnswer: ()->
    @clearTO()
    @currentRound().phase = states.ANSWER
    @trigger "answer:start", "answer:start", @data.roundNum
    testUsers.forEach (user)=>
      @submitBacronym "Round #{@data.roundNum} - Bacronym goes here", user
    @setTO @endAnswer, @answerTime

  endAnswer: ()->
    @clearTO()
    @trigger "answer:end", "answer:end", @data.roundNum
    @setTO @startVote, @bufferTime

  startVote: ()->
    @clearTO()
    @currentRound().phase = states.VOTE
    @trigger "vote:start", "vote:start", @data.roundNum
    @persistBacronyms()
    testUsers.forEach (user)=>
      @submitVote _.sample(testUsers), user
    @setTO @endVote, @voteTime

  endVote: ()->
    @clearTO()
    @currentRound().phase = states.END
    @trigger "vote:end", "vote:end", @data.roundNum
    @persistScores @getScores()
    @persistBacronyms()
    @setTO @endRound, @bufferTime

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
    @currentRound().bacronyms[candidate].votes.push voter

  getScores: ()->
    scores = {}
    for round in @data.rounds
      for user, obj of round.bacronyms
        if not scores[user] then scores[user] = 0
        if 'votes' of obj then scores[user] += obj.votes.length
    scores
     

MicroEvent.mixin Game



     

module.exports = Game
