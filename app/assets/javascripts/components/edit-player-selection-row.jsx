import HeroSelect from './hero-select.jsx'

class EditPlayerSelectionRow extends React.Component {
  onPlayerNameChange(event) {
    this.props.onPlayerNameChange(event.target.value)
  }

  render() {
    const { inputID, player, nameLabel, onHeroSelection,
            mapSegments } = this.props
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
        {mapSegments.map(segment => (
          <td key={segment.id} className="hero-select-cell">
            <HeroSelect
              heroes={player.heroes}
              onChange={heroID => onHeroSelection(heroID, segment.id)}
            />
          </td>
        ))}
      </tr>
    )
  }
}

EditPlayerSelectionRow.propTypes = {
  inputID: React.PropTypes.string.isRequired,
  player: React.PropTypes.object.isRequired,
  onPlayerNameChange: React.PropTypes.func.isRequired,
  nameLabel: React.PropTypes.string.isRequired,
  onHeroSelection: React.PropTypes.func.isRequired,
  mapSegments: React.PropTypes.array.isRequired
}

export default EditPlayerSelectionRow
