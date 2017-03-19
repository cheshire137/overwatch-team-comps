class PlayerSelect extends React.Component {
  constructor(props) {
    super(props)

    this.state = {
      name: props.selectedPlayer.name,
      showNewNameField: false
    }
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      name: nextProps.selectedPlayer.name,
      showNewNameField: false
    })
  }

  onChange(event) {
    const playerID = event.target.value
    if (playerID === 'new') {
      this.setState({ showNewNameField: true })
    } else {
      this.props.onChange(playerID, null)
    }
  }

  onNewNameSet(event) {
    this.setState({ name: event.target.value })
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
    const { selectedPlayer, inputID, players } = this.props

    if (this.state.showNewNameField) {
      return (
        <div className="player-new-name-container">
          <input
            type="text"
            id={inputID}
            placeholder="Player name"
            value={this.state.name}
            onChange={e => this.onNewNameSet(e)}
            className="input"
            autoFocus
          />
          <button
            type="button"
            className="button"
            onClick={e => this.saveNewName(e)}
          ><i className="fa fa-check" aria-hidden="true" /></button>
        </div>
      )
    }

    return (
      <span className="select player-select">
        <select
          onChange={e => this.onChange(e)}
          value={typeof selectedPlayer.id === 'number' ? selectedPlayer.id : ''}
        >
          <option value="">Choose a player</option>
          {players.map(player => (
            <option
              key={player.id}
              value={player.id}
            >{player.name}</option>
          ))}
          <option value="new">Add new player</option>
        </select>
      </span>
    )
  }

  render() {
    const { inputID, label } = this.props
    return (
      <div>
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
  selectedPlayer: React.PropTypes.object.isRequired,
  players: React.PropTypes.array.isRequired,
  onChange: React.PropTypes.func.isRequired,
  label: React.PropTypes.string.isRequired
}

export default PlayerSelect
