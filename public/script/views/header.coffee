R = React.DOM
module.exports = React.createClass
  displayName: 'Header'
  getDefaultProps: ()->
    siteTitle: 'BACRO'
    breadCrumbs: []

  newGame: ()->
    $.get '/game/new', (resp)=> @props.page "/game/#{resp}"

  render: ()->
    console.log 'header'
    R.div className: 'container', [
      R.div className:'navbar-header', [
        #<button type="button" data-toggle="collapse" data-target=".navbar-collapse" class="navbar-toggle"
        # ="icon-bar"></span></button><a href="/" class="navbar-brand">BACRO</a></div>
        R.button className:'navbar-toggle', dataToggle: 'collapse', dataTarget: '.navbar-collapse', [
          R.span className:'sr-only', ['Toggle navigation']
          R.div className:'icon-bar'
          R.div className:'icon-bar'
          R.div className:'icon-bar'
        ]
        R.ul className:'breadcrumb', [
          R.li {}, R.a className:'siteTitle', href:'/', @props.siteTitle
          @props.breadCrumbs.map (el)=>
            R.li {}, R.a className: 'disabled', el
        ]
      ]
      R.div className:'collapse navbar-collapse', [
        R.ul className:'nav navbar-nav navbar-right', [
          R.li {}, R.a href: '/game/new', 'New Game'
          R.li {}, R.a href: '/lobby', 'Lobby'
          R.li {}, R.a href: '/logout', 'Logout'
          R.li {}, R.a {}, @props.username
        ]
      ]
      R.div className:'row', [
        R.div className:'col-xs-12', [
        ]
      ]
    ]
