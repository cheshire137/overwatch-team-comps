import HeroSelect from './hero-select.jsx'
import PlayerSelect from './player-select.jsx'

const EditPlayerSelectionRow = function(props) {
  const { inputID, selectedPlayer, nameLabel, onHeroSelection,
          mapSegments, onPlayerSelection, players, heroes,
          selections } = props
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
      {mapSegments.map((segment, i) => (
        <td
          key={segment.id}
          className={`hero-select-cell ${i % 2 === 0 ? 'even' : 'odd'}-column`}
        >
          <HeroSelect
            heroes={heroes}
            disabled={typeof selectedPlayer.id !== 'number'}
            selectedHeroID={selections[segment.id]}
            onChange={heroID => onHeroSelection(heroID, segment.id)}
          />
        </td>
      ))}
    </tr>
  )
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
