R = React.DOM
fbRoot = require '../fbRoot'
csrfPost = require('../../../lib/csrfPost')

Chat = React.createClass
  displayName: 'Chat'

  getDefaultProps: ()->
    submitURI: '/chat'

  setFbRef: (props)->
    fbRef = fbRoot.child "chats/#{@props.channel}"
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
    $chats = @refs.chats.getDOMNode()
    $chats.scrollTop = $chats.scrollHeight

  componentWillMount: ()->
    @setFbRef @props

  componentWillRecieveProps: (nextProps)->
    @setFbRef nextProps

  getInitialState: ()->
    chats: []

  handleChatSubmit: ()->
    $input = @refs.chatInput.getDOMNode()
    csrfPost @props.submitURI,
      msg: $input.value
      channel: @props.channel

    $input.value = ''
    return false

  render: ->
    chats = @state.chats.map (el)->
      <div className='Chat-chat'>
        <span className='Chat-user'>{el.user}: </span>
        <span className='Chat-body'>{el.msg}</span>
      </div>

    <div className='Chat'>
      <div className='Chat-chats' ref='chats'>{chats}</div>
      <form className='Chat-input-form form' onSubmit={@handleChatSubmit}>
        <div className='input-group'>
          <input
            className='Chat-input form-control'
            ref='chatInput'
            placeholder='Type to chat'
          />
          <span className='input-group-btn'>
            <button className='btn btn-primary'>Chat</button>
          </span>
        </div>
      </form>
    </div>

module.exports = Chat
