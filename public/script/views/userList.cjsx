R = React.DOM

module.exports = React.createClass
  displayName: 'UserList'
  render: ()->
    users = _(@props.users)
      .sortBy 'name'
      .map (obj)->
        <div className='UserList-item' key={obj.name}>
          {obj.name}
        </div>
      .value()

    <div className='UserList'>
      <div className='UserList-list'>
        {users}
      </div>
    </div>
