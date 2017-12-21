import PropTypes from 'prop-types'

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
            isDuplicate={duplicatePicks[segment.id]}
          />
        </td>
      ))}
    </tr>
  )
}

EditPlayerSelectionRow.propTypes = {
  inputID: PropTypes.string.isRequired,
  playerID: PropTypes.number,
  players: PropTypes.array.isRequired,
  onPlayerSelection: PropTypes.func.isRequired,
  nameLabel: PropTypes.string.isRequired,
  onHeroSelection: PropTypes.func.isRequired,
  mapSegments: PropTypes.array.isRequired,
  heroes: PropTypes.array.isRequired,
  selections: PropTypes.object.isRequired,
  duplicatePicks: PropTypes.object.isRequired,
  editPlayer: PropTypes.func.isRequired,
  disabled: PropTypes.bool.isRequired
}

export default EditPlayerSelectionRow
