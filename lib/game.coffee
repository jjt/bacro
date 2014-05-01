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
      numRounds: 8
      answerTime: 3500
      bufferTime: 300
      voteTime: 3300

    @data =
      id: id
      rounds: []
      roundNum: 0
      gameState: 'new'

    @opts = _.merge defaults, optsIn
    @timeouts = []

    @fbRef = fb.child "games/#{@data.id}"
    
  clearTO: ()->
    clearTimeout timeout for timeout in @timeouts
    @timeouts = []
  
  setTO: (fn, delay)->
    @timeouts.push setTimeout fn.bind(this), delay

  currentRound: ()->
    @data.rounds[@data.roundNum]

  persistGame: ()->
    @fbRef.set @data

  persistRoundNum: (roundNum = @data.roundNum)->
    @fbRef.child("roundNum").set roundNum

  persistScores: (scores = @getScores(), roundNum = @data.roundNum)->
    @fbRef.child("scores").set scores

  persistVotes: (roundNum = @data.roundNum)->
    @fbRef.child("rounds/#{roundNum}/votes").set @currentRound().votes

  persistRound: (anonymousBacronyms)->
    round = _.cloneDeep @currentRound()
    # In voting phase, turn the {user: {bacronym}, ... } object into an array
    if anonymousBacronyms?
      round.bacronyms = _.pluck round.bacronyms, 'bacronym'
    @fbRef.child("rounds/#{round.roundNum}").set round

  persistBacronyms: (anonymous) ->
    bacronyms = @currentRound().bacronyms
    roundNum = @data.roundNum
    if anonymous?
      console.log 'anon'
      bacronyms = _.map bacronyms, (bacronym, user)=>
        bacronym
    @fbRef.child("rounds/#{roundNum}/bacronyms/").set bacronyms


  startGame: ()->
    @data.gameState = 'started'
    @persistGame()
    @nextRound()

  nextRound: ()->
    @clearTO()
    @data.roundNum = @data.rounds.length

    console.log 'nextRound'
    if @data.roundNum == @opts.numRounds
      return @endGame()

    @data.rounds.push
      acronym: acronym _.random(3,6)
      bacronyms: {}
      phase: 'start'
      started: nowISO()
      roundNum: @data.roundNum
      votes: {}

    @persistRoundNum()

    @trigger "round:start", "round:start", @data.roundNum
    @persistRound @currentRound()
    @setTO @startAnswer, @opts.bufferTime

  startAnswer: ()->
    @clearTO()
    @currentRound().phase = 'answer'
    @trigger "answer:start", "answer:start", @data.roundNum
    testUsers.forEach (user)=>
      @submitBacronym "Round #{@data.roundNum} #{user} - Bacronym goes here", user
    @setTO @endAnswer, @opts.answerTime

  endAnswer: ()->
    @clearTO()
    @trigger "answer:end", "answer:end", @data.roundNum
    @setTO @startVote, @opts.bufferTime

  startVote: ()->
    @clearTO()
    @currentRound().phase = 'vote'
    @trigger "vote:start", "vote:start", @data.roundNum
    #@persistBacronyms()
    @persistRound('anonymousBacronyms')
    testUsers.forEach (user)=>
      @submitVote _.sample(testUsers), user
    @setTO @endVote, @opts.voteTime

  endVote: ()->
    @clearTO()
    @currentRound().phase = 'end'
    @trigger "vote:end", "vote:end", @data.roundNum
    @persistScores @getScores()
    #@persistVotes()
    #@persistBacronyms()
    @persistRound()
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

  getScores: ()->
    scores = {}
    for round in @data.rounds
      for voter, candidate of round.votes
        if not scores[candidate] then scores[candidate] = 0
        scores[candidate]++
    scores
     

MicroEvent.mixin Game



     

module.exports = Game
