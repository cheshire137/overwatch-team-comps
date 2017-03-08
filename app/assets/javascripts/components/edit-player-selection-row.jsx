import HeroSelect from './hero-select.jsx'

class EditPlayerSelectionRow extends React.Component {
  onPlayerNameChange(event) {
    this.props.onPlayerNameChange(event.target.value)
  }

  render() {
    const { inputID, player, nameLabel, onHeroSelection } = this.props
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
          <HeroSelect
            heroes={player.heroes}
            onChange={heroID => onHeroSelection(heroID)}
          />
        </td>
        <td className="hero-select-cell">
          <HeroSelect
            heroes={player.heroes}
            onChange={heroID => onHeroSelection(heroID)}
          />
        </td>
        <td className="hero-select-cell">
          <HeroSelect
            heroes={player.heroes}
            onChange={heroID => onHeroSelection(heroID)}
          />
        </td>
        <td className="hero-select-cell">
          <HeroSelect
            heroes={player.heroes}
            onChange={heroID => onHeroSelection(heroID)}
          />
        </td>
        <td className="hero-select-cell">
          <HeroSelect
            heroes={player.heroes}
            onChange={heroID => onHeroSelection(heroID)}
          />
        </td>
        <td className="hero-select-cell">
          <HeroSelect
            heroes={player.heroes}
            onChange={heroID => onHeroSelection(heroID)}
          />
        </td>
      </tr>
    )
  }
}

EditPlayerSelectionRow.propTypes = {
  inputID: React.PropTypes.string.isRequired,
  player: React.PropTypes.object.isRequired,
  onPlayerNameChange: React.PropTypes.func.isRequired,
  nameLabel: React.PropTypes.string.isRequired,
  onHeroSelection: React.PropTypes.func.isRequired
}

export default EditPlayerSelectionRow
