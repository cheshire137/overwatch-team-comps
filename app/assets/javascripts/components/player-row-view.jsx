class PlayerRowView extends React.Component {
  mapSegment(segment) {
    const { heroes, selections } = this.props
    const heroID = selections[segment.id]
    if (typeof heroID !== 'number') {
      return (
        <td key={segment.id} className="empty-selection hero-select-cell">
          &mdash;
        </td>
      )
    }

    const hero = heroes.filter(h => h.id === heroID)[0]
    return (
      <td key={segment.id} className="hero-select-cell">
        <img
          src={hero.image}
          alt={hero.name}
          className="hero-portrait"
        />
        <span className="hero-name">{hero.name}</span>
      </td>
    )
  }

  playerCell() {
    const { player } = this.props
    if (player.name.length < 1) {
      return (
        <td className="empty-selection player-cell">
          &mdash;
        </td>
      )
    }

    return (
      <td className="player-cell">
        {player.name}
      </td>
    )
  }

  render() {
    const { mapSegments } = this.props
    return (
      <tr>
        {this.playerCell()}
        {mapSegments.map(segment => this.mapSegment(segment))}
      </tr>
    )
  }
}

PlayerRowView.propTypes = {
  heroes: React.PropTypes.array.isRequired,
  player: React.PropTypes.object.isRequired,
  selections: React.PropTypes.object.isRequired,
  mapSegments: React.PropTypes.array.isRequired
}

export default PlayerRowView
