class PlayerSelect extends React.Component {
  constructor(props) {
    super(props)
    this.state = { name: '', showNewNameField: false }
  }

  onChange(event) {
    const newPlayerID = event.target.value
    if (newPlayerID === 'new') {
      this.setState({ showNewNameField: true })
    } else {
      this.props.onChange(newPlayerID, null)
    }
  }

  onNewNameKeyDown(event) {
    if (event.keyCode === 27) { // Esc
      this.setState({ showNewNameField: false })
    } else if (event.keyCode === 13) { // Enter
      this.saveNewName(event)
    }
  }

  onNewNameSet(event) {
    this.setState({ name: event.target.value })
  }

  editPlayer(event) {
    event.currentTarget.blur()
    this.props.editPlayer()
  }

  saveNewName(event) {
    event.preventDefault()

    const name = this.state.name
    if (name.trim().length < 1) {
      return
    }

    const existingNames = this.props.players.map(p => p.name)
    if (existingNames.indexOf(name) > -1) {
      return
    }

    this.props.onChange(null, name)
  }

  selectOrTextField() {
    const { playerID, inputID, players, disabled } = this.props

    if (this.state.showNewNameField) {
      return (
        <div className="player-new-name-container">
          <input
            type="text"
            id={inputID}
            placeholder="Player name"
            disabled={disabled}
            value={this.state.name}
            onChange={e => this.onNewNameSet(e)}
            onKeyDown={e => this.onNewNameKeyDown(e)}
            className="input player-name-input"
            autoFocus
          />
          <div className="button-wrapper">
            <button
              type="button"
              className="button"
              disabled={disabled}
              onClick={e => this.saveNewName(e)}
            ><i className="fa fa-check" aria-hidden="true" /></button>
          </div>
        </div>
      )
    }

    const isPlayerSelected = typeof playerID === 'number'

    return (
      <div className="existing-player-container">
        <span
          className={`select player-select ${disabled ? 'is-disabled' : ''}`}
        >
          <select
            onChange={e => this.onChange(e)}
            disabled={disabled}
            value={isPlayerSelected ? playerID : ''}
          >
            {isPlayerSelected ? '' : (
              <option value="">Player</option>
            )}
            {players.map(player => (
              <option
                key={player.id}
                value={player.id}
              >{player.name}</option>
            ))}
            <option value="new">Add new player</option>
          </select>
        </span>
        {isPlayerSelected ? (
          <button
            type="button"
            disabled={disabled}
            className="button-link edit-player-button"
            onClick={e => this.editPlayer(e)}
          ><i className="fa fa-cog" aria-hidden="true" /></button>
        ) : ''}
      </div>
    )
  }

  render() {
    const { inputID, label } = this.props
    return (
      <div className="player-select-container">
        <label
          htmlFor={inputID}
          className="label"
        >{label}</label>
        {this.selectOrTextField()}
      </div>
    )
  }
}

PlayerSelect.propTypes = {
  inputID: React.PropTypes.string.isRequired,
  playerID: React.PropTypes.number,
  players: React.PropTypes.array.isRequired,
  onChange: React.PropTypes.func.isRequired,
  label: React.PropTypes.string.isRequired,
  editPlayer: React.PropTypes.func.isRequired,
  disabled: React.PropTypes.bool.isRequired
}

export default PlayerSelect
