UserList = require './userList'
Gamelist = require './gamelist'
Chat = require './chat'
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

    R.div {className: "Panel-body container Lobby"}, [
      R.div className:'row Panel-fh-row', [
        R.div className:'Panel-left col-sm-4 col-lg-3', [
          R.div className:'RoundBadge', [
            R.h3 className:'Game-round', "This is the"
            R.p className: "Acronym-acronym acronym-len-5", "LOBBY"
            R.p className: "Game-phase", "Have fun!"
          ]
          #UserList {users}
        ]
        R.div className:'Panel-main col-sm-8 col-lg-5', [
          R.div className:'Game-MainComponent', [
            Gamelist gamelist: @state.gamelist
          ]
        ]
        R.div className:'Panel-right col-md-12 col-lg-4', Chat channel: 'lobby'
      ]
    ]
