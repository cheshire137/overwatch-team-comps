class PlayerEditModal extends React.Component {
  onClose(event) {
    event.currentTarget.blur()
    this.props.close()
  }

  render() {
    const { isOpen } = this.props
    return (
      <div>
        <div className={`modal-overlay modal-overlay-${isOpen ? 'active' : 'hide'}`} />
        <div className="modal" style={{ display: isOpen ? 'block' : 'none' }}>
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
  close: React.PropTypes.func.isRequired,
  isOpen: React.PropTypes.bool.isRequired
}

export default PlayerEditModal
