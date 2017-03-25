class PlayerEditModal extends React.Component {
  onClose(event) {
    event.currentTarget.blur()
    this.props.close()
  }

  render() {
    return (
      <div>
        <div className="modal-overlay modal-overlay-active" />
        <div className="modal">
          <div className="modal-popup">
            <div className="modal-content">
              <h2 className="modal-header">
                Edit Player
              </h2>
            </div>
            <button
              type="button"
              className="modal-close"
              aria-label="Close modal"
              onClick={e => this.onClose(e)}
            ><i className="fa fa-times" aria-hidden="true" /></button>
          </div>
        </div>
      </div>
    )
  }
}

PlayerEditModal.propTypes = {
  playerID: React.PropTypes.number.isRequired,
  close: React.PropTypes.func.isRequired
}

export default PlayerEditModal
