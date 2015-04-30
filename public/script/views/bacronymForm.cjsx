R = React.DOM

module.exports = React.createClass
  displayName: 'BacronymForm'

  getDefaultProperties: ()->
    userBacronym: null

  handleBacronymSubmit: (e)->
    e.preventDefault()
    $input = @refs.bacronymInput.getDOMNode()
    bacronym = $input.value
    # TODO: Bacronym validation
    $input = ''
    @props.submitBacronym @refs.bacronymInput.getDOMNode().value

  render: ()->
    if not @props.userBacronym?
      userBacronym = <p className='Game-userBacronym no-bacronym'>Submit a bacronym</p>
      placeholder = "Type in a bacronym and hit enter"
    else
      userBacronym = <p className='Game-userBacronym'>{@props.userBacronym}</p>
      placeholder = "Enter a new bacronym and hit enter (replaces old one)"

    <form className='Game-bacronym-form' onSubmit=@handleBacronymSubmit>
      {userBacronym}
      <div className='form-group'>
        <input
          className='Game-bacronymInput form-control input-lg'
          type='text'
          ref='bacronymInput'
          placeholder=placeholder
        />
      </div>
    </form>
