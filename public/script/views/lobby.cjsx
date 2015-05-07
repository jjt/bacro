classnames = require 'classnames'

UserList = require './userList.cjsx'
Gamelist = require './gamelist.cjsx'
Chat = require './chat.cjsx'
Intro = require './intro.cjsx'

FirebaseMixin = require '../firebaseMixin'

module.exports = React.createClass
  mixins: [FirebaseMixin]
  displayName: 'Lobby'

  componentWillUnmount: ()->
    console.log 'componentWillUnmount'
    clearTimeout @gamelistTimeout

  getInitialState: ()->
    gamelist: []

  firebaseInitFn: ()->
    console.log 'firebaseInitFn'
    @firebaseInit 'gamelist'
    @getGamelist()


  getGamelist: ()->
    clearTimeout @gamelistTimeout
    @gamelistTimeout = setTimeout @getGamelist, 5000
    console.log 'getGamelist', @firebaseRefRoot
    @firebaseOnce null, 'value', (snapshot)=>
      @setState
        gamelist: snapshot.val()


  render: ->
    intro = if @props.showIntro then <Intro/> else null
    users = _.map require('../../../lib/names'), (name)->
      {name}

    <div className="Lobby">
      <div className="Panel-header">
        <div className='container'>
          <div className="row">
            {intro}
          </div>
          <div className="Lobby-playControls row">
            <div className="col-sm-6">
              <a href="/game/quick" className="Lobby-quickPlay btn btn-lg btn-white">Quick Play</a>
            </div>
            <div className="col-sm-6">
              <a href="/game/new" className="Lobby-createGame btn btn-lg btn-white">Create Game</a>
            </div>
          </div>
        </div>
      </div>
      <div className="container">
        <div className="row">
          <div className="col-sm-6 col-md-8">
            <Gamelist gamelist={@state.gamelist} />
          </div>
          <div className='col-sm-6 col-md-4'>
            <Chat channel='lobby' />
          </div>
        </div>
      </div>
    </div>
