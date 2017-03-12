import HeroSelect from './hero-select.jsx'
import PlayerSelect from './player-select.jsx'

class EditPlayerSelectionRow extends React.Component {
  getSelectedHeroID(segment) {
    const needle = segment.id
    const haystack = this.props.selectedPlayer.heroes
    const heroes = haystack.filter(hero =>
      hero.mapSegmentIDs && hero.mapSegmentIDs.indexOf(needle) > -1
    )
    if (heroes.length > 0) {
      return heroes[0].id
    }
    return null
  }

  render() {
    const { inputID, selectedPlayer, nameLabel, onHeroSelection,
            mapSegments, onPlayerSelection, players } = this.props
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
              heroes={selectedPlayer.heroes}
              selectedHeroID={this.getSelectedHeroID(segment)}
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
  mapSegments: React.PropTypes.array.isRequired
}

export default EditPlayerSelectionRow
