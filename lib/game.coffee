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
      rounds: []
      answerTime: 1300
      bufferTime: 300
      voteTime: 1300
      curRoundNum: 0
      timeouts: []

    _.assign this, defaults, optsIn

    @fbRef = fb.child "games/#{@id}"
    
  clearTO: ()->
    clearTimeout timeout for timeout in @timeouts
    @timeouts = []
  
  setTO: (fn, delay)->
    @timeouts.push setTimeout fn.bind(this), delay

  currentRound: ()->
    @rounds[@curRoundNum]

  persistRoundNum: (roundNum = @curRoundNum)->
    @fbRef.child("roundNum").set roundNum

  persistScores: (score = @getScores(), roundNum = @curRoundNum)->
    @fbRef.child("score").set score

  persistVotes: (roundNum = @curRoundNum)->
    @fbRef.child("rounds/#{roundNum}/votes").set @currentRound().votes

  persistRound: (round = @currentRound())->
    fb.child("games/#{@id}/rounds/#{round.roundNum}").set round

  persistBacronyms: (bacronyms = @currentRound().bacronyms, roundNum = @curRoundNum) ->
    fb.child("games/#{@id}/rounds/#{roundNum}/bacronyms/").set bacronyms

  nextRound: ()->
    @clearTO()
    @curRoundNum = @rounds.length

    if @curRoundNum == @numRounds
      return @endGame()

    @rounds.push
      acronym: acronym _.random(3,6)
      bacronyms: {}
      phase: states.START
      started: nowISO()
      roundNum: @curRoundNum
      votes: {}

    @persistRoundNum()

    @trigger "round:start", "round:start", @curRoundNum
    @persistRound @currentRound()
    @setTO @startAnswer, @bufferTime

  startAnswer: ()->
    @clearTO()
    @currentRound().phase = states.ANSWER
    @trigger "answer:start", "answer:start", @curRoundNum
    testUsers.forEach (user)=>
      @submitBacronym "Round #{@curRoundNum} - Bacronym goes here", user
    @setTO @endAnswer, @answerTime

  endAnswer: ()->
    @clearTO()
    @trigger "answer:end", "answer:end", @curRoundNum
    @setTO @startVote, @bufferTime

  startVote: ()->
    @clearTO()
    @currentRound().phase = states.VOTE
    @trigger "vote:start", "vote:start", @curRoundNum
    @persistBacronyms()
    testUsers.forEach (user)=>
      @submitVote _.sample(testUsers), user
    @setTO @endVote, @voteTime

  endVote: ()->
    @clearTO()
    @currentRound().phase = states.END
    @trigger "vote:end", "vote:end", @curRoundNum
    @persistScores @getScores()
    @persistBacronyms()
    @setTO @endRound, @bufferTime

  endRound: ()->
    @clearTO()
    @trigger 'round:end', 'round:end', @curRoundNum
    @nextRound()

  endGame: ()->
    @trigger 'game:end', 'game:end', @curRoundNum

  # {user, answer, timestamp}
  submitBacronym: (bacronym, user, time = nowISO(), votes = [])->
    @currentRound().bacronyms[user] = {bacronym, time, votes}
    @trigger 'bacronym', {user, bacronym, time, votes}

  submitVote: (candidate, voter) ->
    @currentRound().bacronyms[candidate].votes.push voter

  getScores: ()->
    scores = {}
    for round in @rounds
      for user, obj of round.bacronyms
        if not scores[user] then scores[user] = 0
        if 'votes' of obj then scores[user] += obj.votes.length
    scores
     

MicroEvent.mixin Game



     

module.exports = Game
