R = React.DOM
module.exports = React.createClass
  displayName: 'Header'
  getDefaultProps: ()->
    siteTitle: 'BACRO'
    breadCrumbs: []

  newGame: ()->
    $.get '/game/new', (resp)=> @props.page "/game/#{resp}"

  render: ()->

    breadCrumbs = @props.breadCrumbs.map (el)=>
      <li><a className='disabled'>{el}</a></li>

    <div className='container'>
      <div className='navbar-header'>
        <button className='navbar-toggle' dataToggle='collapse' dataTarget='.navbar-collapse'>
          <span className='sr-only'>Toggle navigation</span>
          <div className='icon-bar'></div>
          <div className='icon-bar'></div>
          <div className='icon-bar'></div>
        </button>
        <ul className='breadcrumb'>
          <li><a className='siteTitle' href='/'>{@props.siteTitle}</a></li>
          {breadCrumbs}
        </ul>
      </div>
      <div className='collapse navbar-collapse'>
        <ul className='nav navbar-nav navbar-right'>
          <li><a href='/game/new'>New Game</a></li>
          <li><a href='/lobby'>Lobby</a></li>
          <li><a href='/logout'>Logout</a></li>
          <li><a>{@props.username}</a></li>
        </ul>
      </div>
      <div className='row'>
        <div className='col-xs-12'></div>
      </div>
    </div>
