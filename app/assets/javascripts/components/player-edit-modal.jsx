import PropTypes from 'prop-types'

import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

class PlayerEditModal extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      playerName: props.playerName,
      battletag: props.battletag,
      showDeleteConfirmation: false,
      isRequestOut: false
    }
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      playerName: nextProps.playerName,
      battletag: nextProps.battletag,
      showDeleteConfirmation: false,
      isRequestOut: false
    })
  }

  onBattletagChange(event) {
    this.setState({ battletag: event.target.value })
  }

  onClose(event) {
    event.currentTarget.blur()
    this.props.close()
  }

  onKeyDown(event) {
    if (event.keyCode === 27) { // Esc
      this.props.close()
    } else if (event.keyCode === 13) { // Enter
      event.preventDefault()
      this.save(event)
    }
  }

  onPlayerDeleteError(error) {
    console.error('failed to delete player', error)
    this.setState({ isRequestOut: false })
  }

  onPlayerNameChange(event) {
    this.setState({ playerName: event.target.value })
  }

  onPlayerUpdateError(error) {
    console.error('failed to update player', error)
    this.setState({ isRequestOut: false })
  }

  onCompositionLoaded(composition) {
    this.props.close(composition)
  }

  cancelDelete(event) {
    event.currentTarget.blur()
    this.setState({ showDeleteConfirmation: false })
  }

  confirmDelete(event) {
    event.currentTarget.blur()
    this.setState({ showDeleteConfirmation: true })
  }

  contents() {
    if (!this.props.isOpen) {
      return null
    }

    const { showDeleteConfirmation, isRequestOut } = this.state

    return (
      <div className="modal-popup">
        {showDeleteConfirmation ? this.deleteConfirmation() : this.editFields()}
        {isRequestOut ? '' : (
          <button
            type="button"
            className="modal-close"
            aria-label="Close modal"
            onClick={e => this.onClose(e)}
          ><i className="fa fa-times" aria-hidden="true" /></button>
        )}
      </div>
    )
  }

  delete(event) {
    event.currentTarget.blur()

    const { playerID, compositionID } = this.props
    const api = new OverwatchTeamCompsApi()

    const body = { composition_id: compositionID }

    this.setState({ isRequestOut: true }, () => {
      api.deletePlayer(playerID, body).
        then(newComp => this.onCompositionLoaded(newComp)).
        catch(err => this.onPlayerDeleteError(err))
    })
  }

  deleteConfirmation() {
    const { playerName } = this.props
    return (
      <div className="modal-content">
        <h2 className="modal-header">
          Confirm Delete Player
        </h2>
        <p>
          Are you sure you want to delete <strong>{playerName}</strong>?
        </p>
        <button
          type="button"
          className="button is-danger"
          onClick={e => this.delete(e)}
        >Yes, delete</button>
        <button
          type="button"
          className="button is-normal"
          onClick={e => this.cancelDelete(e)}
        >No, do not delete</button>
      </div>
    )
  }

  editFields() {
    const { playerName, battletag, isRequestOut } = this.state

    return (
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
            onKeyDown={e => this.onKeyDown(e)}
            placeholder="Player name"
            disabled={isRequestOut}
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
            disabled={isRequestOut}
            onChange={e => this.onBattletagChange(e)}
            className="input"
            onKeyDown={e => this.onKeyDown(e)}
            placeholder="Battle.net username"
          />
        </div>
        <div className="clearfix">
          {isRequestOut ? '' : (
            <button
              type="button"
              className="delete-player-button button-link"
              onClick={e => this.confirmDelete(e)}
            ><i className="fa fa-trash" aria-hidden="true" /> Delete player</button>
          )}
          <button
            type="button"
            className="button is-primary"
            disabled={isRequestOut}
            onClick={e => this.save(e)}
          >Save</button>
        </div>
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

    this.setState({ isRequestOut: true }, () => {
      api.updatePlayer(playerID, body).
        then(newComp => this.onCompositionLoaded(newComp)).
        catch(err => this.onPlayerUpdateError(err))
    })
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
  playerID: PropTypes.number,
  compositionID: PropTypes.number,
  playerName: PropTypes.string,
  battletag: PropTypes.string,
  close: PropTypes.func.isRequired,
  isOpen: PropTypes.bool.isRequired
}

export default PlayerEditModal
