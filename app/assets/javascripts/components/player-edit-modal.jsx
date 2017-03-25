import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

class PlayerEditModal extends React.Component {
  static onPlayerUpdateError(error) {
    console.error('failed to update player', error)
  }

  constructor(props) {
    super(props)
    this.state = {
      playerName: props.playerName,
      battletag: props.battletag
    }
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      playerName: nextProps.playerName,
      battletag: nextProps.battletag
    })
  }

  onBattletagChange(event) {
    this.setState({ battletag: event.target.value })
  }

  onClose(event) {
    event.currentTarget.blur()
    this.props.close()
  }

  onPlayerNameChange(event) {
    this.setState({ playerName: event.target.value })
  }

  onSaved(composition) {
    this.props.close(composition)
  }

  contents() {
    const { isOpen } = this.props
    if (!isOpen) {
      return null
    }

    const { playerName, battletag } = this.state
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
              value={playerName || ''}
              onChange={e => this.onPlayerNameChange(e)}
              className="input"
              placeholder="Player name"
              autoFocus
            />
          </div>
          <div className="field">
            <label
              className="label"
              htmlFor="edit_player_battletag"
            >Battletag:</label>
            <input
              type="text"
              id="edit_player_battletag"
              value={battletag || ''}
              onChange={e => this.onBattletagChange(e)}
              className="input"
              placeholder="Battle.net username"
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

    const { playerID, compositionID } = this.props
    const api = new OverwatchTeamCompsApi()

    const body = {
      name: this.state.playerName,
      battletag: this.state.battletag,
      composition_id: compositionID
    }

    api.updatePlayer(playerID, body).
      then(newComp => this.onSaved(newComp)).
      catch(err => PlayerEditModal.onPlayerUpdateError(err))
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
  compositionID: React.PropTypes.number,
  playerName: React.PropTypes.string,
  battletag: React.PropTypes.string,
  close: React.PropTypes.func.isRequired,
  isOpen: React.PropTypes.bool.isRequired
}

export default PlayerEditModal
