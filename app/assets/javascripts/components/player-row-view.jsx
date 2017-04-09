import PropTypes from 'prop-types'

class PlayerRowView extends React.Component {
  mapSegment(segment, index) {
    const { heroes, selections } = this.props
    const heroID = selections[segment.id]
    const classes = ['hero-select-cell', index % 2 === 0 ? 'even-column' : 'odd-column']

    if (typeof heroID !== 'number') {
      classes.push('empty-selection')
      return (
        <td key={segment.id} className={classes.join(' ')}>
          &mdash;
        </td>
      )
    }

    const hero = heroes.filter(h => h.id === heroID)[0]
    return (
      <td key={segment.id} className={classes.join(' ')}>
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
    const { name } = this.props
    if (name.length < 1) {
      return (
        <td className="empty-selection player-cell">
          &mdash;
        </td>
      )
    }

    return (
      <td className="player-cell">
        {name}
      </td>
    )
  }

  render() {
    const { mapSegments } = this.props
    return (
      <tr>
        {this.playerCell()}
        {mapSegments.map((segment, i) => this.mapSegment(segment, i))}
      </tr>
    )
  }
}

PlayerRowView.propTypes = {
  heroes: PropTypes.array.isRequired,
  name: PropTypes.string.isRequired,
  selections: PropTypes.object.isRequired,
  mapSegments: PropTypes.array.isRequired
}

export default PlayerRowView
