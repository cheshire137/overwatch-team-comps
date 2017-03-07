class EditPlayerSelectionRow extends React.Component {
  onPlayerNameChange(event) {
    this.props.onPlayerNameChange(event.target.value)
  }

  render() {
    const { inputID, player, nameLabel } = this.props
    return (
      <tr>
        <td className="player-cell">
          <label
            htmlFor={inputID}
            className="label"
          >{nameLabel}</label>
          <input
            type="text"
            id={inputID}
            placeholder="Player name"
            value={player.name}
            className="input"
            onChange={e => this.onPlayerNameChange(e)}
          />
        </td>
        <td className="hero-select-cell">
          <span className="select">
            <select><option>Select hero</option></select>
          </span>
        </td>
        <td className="hero-select-cell">
          <span className="select">
            <select><option>Select hero</option></select>
          </span>
        </td>
        <td className="hero-select-cell">
          <span className="select">
            <select><option>Select hero</option></select>
          </span>
        </td>
        <td className="hero-select-cell">
          <span className="select">
            <select><option>Select hero</option></select>
          </span>
        </td>
        <td className="hero-select-cell">
          <span className="select">
            <select><option>Select hero</option></select>
          </span>
        </td>
        <td className="hero-select-cell">
          <span className="select">
            <select><option>Select hero</option></select>
          </span>
        </td>
      </tr>
    )
  }
}

EditPlayerSelectionRow.propTypes = {
  inputID: React.PropTypes.string.isRequired,
  player: React.PropTypes.object.isRequired,
  onPlayerNameChange: React.PropTypes.func.isRequired,
  nameLabel: React.PropTypes.string.isRequired
}

export default EditPlayerSelectionRow
