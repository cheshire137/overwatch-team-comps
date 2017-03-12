import HeroSelect from './hero-select.jsx'
import PlayerSelect from './player-select.jsx'

class EditPlayerSelectionRow extends React.Component {
  getSelectedHeroID(segment) {
    const needle = segment.id
    const haystack = this.props.player.heroes
    const heroes = haystack.filter(hero =>
      hero.mapSegmentIDs && hero.mapSegmentIDs.indexOf(needle) > -1
    )
    if (heroes.length > 0) {
      return heroes[0].id
    }
    return null
  }

  render() {
    const { inputID, player, nameLabel, onHeroSelection,
            mapSegments } = this.props
    return (
      <tr>
        <td className="player-cell">
          <PlayerSelect
            inputID={inputID}
            label={nameLabel}
            player={player}
            onChange={name => this.props.onPlayerNameChange(name)}
          />
        </td>
        {mapSegments.map(segment => (
          <td key={segment.id} className="hero-select-cell">
            <HeroSelect
              heroes={player.heroes}
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
  player: React.PropTypes.object.isRequired,
  onPlayerNameChange: React.PropTypes.func.isRequired,
  nameLabel: React.PropTypes.string.isRequired,
  onHeroSelection: React.PropTypes.func.isRequired,
  mapSegments: React.PropTypes.array.isRequired
}

export default EditPlayerSelectionRow
