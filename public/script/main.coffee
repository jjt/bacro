R = React.DOM
cx = React.addons.classSet

fbRootURL = 'https://bacrogame.firebaseio.com'
fbRoot = new Firebase fbRootURL

clargs = ()-> console.log arguments

csrfPost = (url, body)->
  $.ajax
    type: 'POST'
    url: url
    data: body
    dataType: 'json'
    headers:
      'X-CSRF-Token': csrftoken


ReactMultiplayerMixin.setFirebaseRoot fbRoot

Chat = React.createClass
  
  setFbRef: (props)->
    console.log 'setFbref'
    fbRef = fbRoot.child "chats/#{props.gameId}"
    #fbRef.push
      #user: "TESTO"
      #msg: "#{(new Date).getTime()} HEEEYYYYY"

    fbRef.once 'value', (snapshot)=>
      chats = _.values snapshot.val()
      chats = _.sortBy chats, 'id'
      @setState {chats}

    fbRef.on 'child_added', (snapshot)=>
      msg = snapshot.val()
      chats = @state.chats
      chats.push msg
      @setState {chats}

  componentDidUpdate: ()->
    console.log 'cDU'
    $chats = @refs.chats.getDOMNode()
    $chats.scrollTop = $chats.scrollHeight

  componentWillMount: ()->
    console.log 'cWM'
    @setFbRef @props

  componentWillRecieveProps: (nextProps)->
    console.log 'cWRP', nextProps
    @setFbRef nextProps

  getInitialState: ()->
    chats: []

  handleChatSubmit: ()->
    $input = @refs.chatInput.getDOMNode()
    csrfPost "/game/#{@props.gameId}/chat",
      msg: $input.value
      channel: @props.gameId

    $input.value = ''
    #$.post "/game/#{@props.gameId}/chat", {msg}
    return false

  render: ->
    console.log @state.chats
    R.div {className: 'Chat'}, [
      R.div {className: 'Chat-chats', ref: 'chats'}, @state.chats.map (el)->
        R.div {}, [
          R.strong {}, el.user
          ": " + el.msg
        ]
      R.form {className: 'form', onSubmit: @handleChatSubmit }, [
        R.div {className: 'input-group'}, [
          R.input
            className: 'Chat-input form-control'
            ref: 'chatInput'
            placeholder: 'Type to chat'
          R.span {className: 'input-group-btn'},
            R.button {className: 'btn btn-primary'}, 'Chat'
        ]
      ]
    ]
      

Lobby = React.createClass
  render: ->
    R.div {className: 'Lobby'}, [
      R.h1 {}, 'Lobby'
      R.div {id: 'gameList', ref: 'gameList'}
      R.div {id: 'userList', ref: 'userList'}
      R.a {className: 'btn btn-primary', href: '#/newgame'}, 'New Game'
    ]
       

Game = React.createClass
  componentWillMount: ->
    fb = fbRoot.child "games/#{@props.id}"
    fb.set
      round:1

  render: ->
    R.div {className: 'Game'}, [
      R.h1 {}, "Game #{@props.id}"
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
    show Game, {id: id, key: id}

router.init('/lobby')
