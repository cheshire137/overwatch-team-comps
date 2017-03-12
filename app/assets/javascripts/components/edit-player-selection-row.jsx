import HeroSelect from './hero-select.jsx'
import PlayerSelect from './player-select.jsx'

class EditPlayerSelectionRow extends React.Component {
  render() {
    const { inputID, selectedPlayer, nameLabel, onHeroSelection,
            mapSegments, onPlayerSelection, players, heroes,
            selections } = this.props
    return (
      <tr>
        <td className="player-cell">
          <PlayerSelect
            inputID={inputID}
            label={nameLabel}
            selectedPlayer={selectedPlayer}
            players={players}
            onChange={(playerID, name) => onPlayerSelection(playerID, name)}
          />
        </td>
        {mapSegments.map(segment => (
          <td key={segment.id} className="hero-select-cell">
            <HeroSelect
              heroes={heroes}
              selectedHeroID={selections[segment.id]}
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
  selectedPlayer: React.PropTypes.object.isRequired,
  players: React.PropTypes.array.isRequired,
  onPlayerSelection: React.PropTypes.func.isRequired,
  nameLabel: React.PropTypes.string.isRequired,
  onHeroSelection: React.PropTypes.func.isRequired,
  mapSegments: React.PropTypes.array.isRequired,
  heroes: React.PropTypes.array.isRequired,
  selections: React.PropTypes.object.isRequired
}

export default EditPlayerSelectionRow
