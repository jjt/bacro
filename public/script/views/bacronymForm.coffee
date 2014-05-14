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
    console.log this.props
    @props.submitBacronym @refs.bacronymInput.getDOMNode().value
  render: ()->
    console.log 'userBacronym', @props.userBacronym
    if not @props.userBacronym?
      userBacronym = R.p className: 'Game-userBacronym no-bacronym', [
        'Submit a bacronym'
      ]
      placeholder = "Type in a bacronym and hit enter"
    else
      userBacronym = R.p className: 'Game-userBacronym', @props.userBacronym
      placeholder = "Enter a new bacronym and hit enter (replaces old one)"

    R.form className: 'Game-bacronym-form', onSubmit: @handleBacronymSubmit, [
      userBacronym
      R.div className: 'form-group',
        R.input
          className: 'Game-bacronymInput form-control input-lg'
          type:'text'
          ref: 'bacronymInput'
          placeholder: placeholder
    ]

