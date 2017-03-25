class PlayerEditModal extends React.Component {
  constructor(props) {
    super(props)
    this.state = { playerName: props.playerName }
  }

  componentWillReceiveProps(nextProps) {
    this.setState({ playerName: nextProps.playerName })
  }

  onClose(event) {
    event.currentTarget.blur()
    this.props.close()
  }

  onPlayerNameChange(event) {
    this.setState({ playerName: event.target.value })
  }

  contents() {
    const { isOpen } = this.props
    if (!isOpen) {
      return null
    }

    const { playerName } = this.state
    return (
      <div className="modal-popup">
        <div className="modal-content">
          <h2 className="modal-header">
            Edit Player
          </h2>
          <div className="field">
            <label
              className="label"
              htmlFor="edit_player_name"
            >Name:</label>
            <input
              type="text"
              id="edit_player_name"
              value={playerName}
              onChange={e => this.onPlayerNameChange(e)}
              className="input"
              autoFocus
            />
          </div>
          <button
            type="button"
            className="button is-primary"
            onClick={e => this.save(e)}
          >Save</button>
        </div>
        <button
          type="button"
          className="modal-close"
          aria-label="Close modal"
          onClick={e => this.onClose(e)}
        ><i className="fa fa-times" aria-hidden="true" /></button>
      </div>
    )
  }

  save(event) {
    event.currentTarget.blur()
  }

  render() {
    const { isOpen } = this.props
    return (
      <div>
        <div className={`modal-overlay modal-overlay-${isOpen ? 'active' : 'hide'}`} />
        <div className="modal" style={{ display: isOpen ? 'block' : 'none' }}>
          {this.contents()}
        </div>
      </div>
    )
  }
}

PlayerEditModal.propTypes = {
  playerID: React.PropTypes.number,
  playerName: React.PropTypes.string,
  close: React.PropTypes.func.isRequired,
  isOpen: React.PropTypes.bool.isRequired
}

export default PlayerEditModal
