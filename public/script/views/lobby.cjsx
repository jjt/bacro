UserList = require './userList.cjsx'
Gamelist = require './gamelist.cjsx'
Chat = require './chat.cjsx'
R = React.DOM

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
    users = _.map require('../../../lib/names'), (name)->
      {name}

    <div className="Panel-body container Lobby">
      <div className='row Panel-fh-row'>
        <div className='Panel-left col-sm-4 col-lg-3'>
          <div className='RoundBadge'>
            <h3 className='Game-round'>This is the</h3>
            <p className="Acronym-acronym acronym-len-5">LOBBY</p>
            <p className="Game-phase">Have fun!<p>
          </div>
        </div>
        <div className='Panel-main col-sm-8 col-lg-5'>
          <div className='Game-MainComponent'>
            <Gamelist gamelist={@state.gamelist} />
          </div>
        </div>
        <div className='Panel-right col-md-12 col-lg-4'>
          <Chat channel='lobby' />
        </div>
      </div>
    </div>
