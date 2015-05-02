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
    @props.submitBacronym @refs.bacronymInput.getDOMNode().value
    $input.value = ''

  render: ()->
    if not @props.userBacronym?
      userBacronym = (
        <p className='Game-userBacronym no-bacronym'>
          <i className="glyphicon glyphicon-hand-up"></i>
          Your bacronym here!
        </p>
      )
      placeholder = "Type in a bacronym and hit enter"
    else
      userBacronym = <p className='Game-userBacronym'>{@props.userBacronym}</p>
      placeholder = "Submit new bacronym"

    <form className='Game-bacronym-form' onSubmit=@handleBacronymSubmit>
      <p className='Game-acronym'>
        {@props.acronym}
      </p>
      <div className='form-group'>
        <input
          className='Game-bacronymInput form-control input-lg'
          type='text'
          ref='bacronymInput'
          placeholder=placeholder
        />
      </div>
      {userBacronym}
    </form>
