import HeroSelect from './hero-select.jsx'
import PlayerSelect from './player-select.jsx'

const EditPlayerSelectionRow = function(props) {
  const { inputID, playerID, nameLabel, onHeroSelection,
          mapSegments, onPlayerSelection, players, heroes,
          selections, editPlayer, disabled, duplicatePicks } = props
  return (
    <tr>
      <td className="player-cell">
        <PlayerSelect
          inputID={inputID}
          label={nameLabel}
          playerID={playerID}
          players={players}
          disabled={disabled}
          onChange={(newPlayerID, newName) =>
            onPlayerSelection(newPlayerID, newName)
          }
          editPlayer={() => editPlayer(playerID)}
        />
      </td>
      {mapSegments.map((segment, i) => (
        <td
          key={segment.id}
          className={`hero-select-cell ${i % 2 === 0 ? 'even' : 'odd'}-column`}
        >
          <HeroSelect
            heroes={heroes}
            disabled={disabled || typeof playerID !== 'number'}
            selectedHeroID={selections[segment.id]}
            onChange={heroID => onHeroSelection(heroID, segment.id)}
            selectID={`${inputID}_segment_${segment.id}`}
            isDuplicate={duplicatePicks[segment.id]}
          />
        </td>
      ))}
    </tr>
  )
}

EditPlayerSelectionRow.propTypes = {
  inputID: React.PropTypes.string.isRequired,
  playerID: React.PropTypes.number,
  players: React.PropTypes.array.isRequired,
  onPlayerSelection: React.PropTypes.func.isRequired,
  nameLabel: React.PropTypes.string.isRequired,
  onHeroSelection: React.PropTypes.func.isRequired,
  mapSegments: React.PropTypes.array.isRequired,
  heroes: React.PropTypes.array.isRequired,
  selections: React.PropTypes.object.isRequired,
  duplicatePicks: React.PropTypes.object.isRequired,
  editPlayer: React.PropTypes.func.isRequired,
  disabled: React.PropTypes.bool.isRequired
}

export default EditPlayerSelectionRow
