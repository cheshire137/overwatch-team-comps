class PlayerSelection extends React.Component {
  render() {
    const { player, mapSegments, selections, heroes } = this.props
    return (
      <tr>
        <td className="player-cell">
          {player.name}
        </td>
        {mapSegments.map(segment => {
          const heroID = selections[segment.id]
          if (typeof heroID !== 'number') {
            return null
          }

          const hero = heroes.filter(h => h.id === heroID)[0]
          return (
            <td key={segment.id} className="hero-select-cell">
              {hero.name}
            </td>
          )
        })}
      </tr>
    )
  }
}

PlayerSelection.propTypes = {
  heroes: React.PropTypes.array.isRequired,
  player: React.PropTypes.object.isRequired,
  selections: React.PropTypes.object.isRequired,
  mapSegments: React.PropTypes.array.isRequired
}

export default PlayerSelection
