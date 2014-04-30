R = React.DOM
cx = React.addons.classSet



clargs = ()-> console.log arguments





Chat = require './chat'

Lobby = React.createClass
  render: ->
    R.div {className: 'Lobby'}, [
      R.h1 {}, 'Lobby'
      R.div {id: 'gameList', ref: 'gameList'}
      R.div {id: 'userList', ref: 'userList'}
      R.a {className: 'btn btn-primary', href: '#/new'}, 'New Game'
    ]
       

Board = React.createClass
  render: ->
    R.div className: 'jumbotron'


Scores = React.createClass
  render: ->
    console.log @props.game.scores
    R.ul className: 'Scores', _.map @props.game.scores, (score, user)=>
      R.li key: user, className: 'clearfix', [
        R.span className: 'Scores-name', user
        R.span className: 'Scores-score', score
      ]

GameStatus = React.createClass
  render: ->
    R.div {className:'GameStatus'},
      R.h3 className:'GameStatus-round', "Round #{@props.game.roundNum}"
      Scores game: @props.game


Game = React.createClass

  render: ->
    R.div {className: 'Game'}, [
      R.div {className: 'row'}, [
        R.div className: 'col-sm-8', Board game: @props.game
        R.div className: 'col-sm-4', GameStatus game: @props.game
      ]
        
      Chat gameId: @props.id
    ]


show = (component, props={})->
  React.renderComponent component(props), document.getElementById('app')

router = new Router
  '/lobby': ()->
    show Lobby
  '/new': ()->
    $.get '/game/new', (resp)=>
      @setRoute "/#{resp}"
  '/:id': (id)->
    console.log 'show game id ' + id
    require('./fbRoot').child("games/#{id}").on 'value', (snapshot)=>
      show Game, game: snapshot.val()

router.init('/lobby')
