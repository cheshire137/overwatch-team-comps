import { debounce } from 'throttle-debounce'

import HeroSelect from './hero-select.jsx'

class EditPlayerSelectionRow extends React.Component {
  constructor(props) {
    super(props)
    this.onPlayerNameChange = debounce(500, this.onPlayerNameChange)
  }

  onPlayerNameChange(name) {
    this.props.onPlayerNameChange(name)
  }

  onPlayerNameKeyUp(event) {
    this.onPlayerNameChange(event.target.value)
  }

  getSelectedHeroID(segment) {
    const needle = segment.id
    const haystack = this.props.player.heroes
    const heroes = haystack.filter(hero => hero.mapSegmentID === needle)
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
          <label
            htmlFor={inputID}
            className="label"
          >{nameLabel}</label>
          <input
            type="text"
            id={inputID}
            placeholder="Player name"
            defaultValue={player.name}
            className="input"
            onKeyUp={this.onPlayerNameKeyUp.bind(this)}
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
