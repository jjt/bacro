module.exports = React.createClass
  render: ->
    console.log 'INTRO'
    <div className="Intro-pane jumbotron">

      <p className="Intro-blurb">
        <span className="Intro-brand">BACRO</span> is a multiplayer game
        where you make bacronyms to earn other players' votes.
      </p>

      <h4>Example:</h4>

      <p className="larger Intro-bacronym">
        <span className="Intro-letter">B</span>acro: 
        <span className="Intro-letter">A</span>cronyms' 
        <span className="Intro-letter">C</span>omical 
        <span className="Intro-letter">R</span>oots 
        <span className="Intro-letter">O</span>nline
      </p>
    </div>
