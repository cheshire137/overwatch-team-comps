import PropTypes from 'prop-types'
import renderHTML from 'react-render-html'

import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

import MapSegmentHeader from './map-segment-header.jsx'
import PlayerRowView from './player-row-view.jsx'

const days = [
  'Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'
]
const months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug',
  'Sep', 'Oct', 'Nov', 'Dec'
]

class CompositionView extends React.Component {
  static onCompositionFetchError(error) {
    console.error('failed to load composition data for view', error)
  }

  constructor(props) {
    super(props)
    this.state = {
      notes: null,
      battletag: null,
      mapSegments: [],
      updatedAt: null,
      name: null,
      mapName: null,
      mapSlug: null,
      mapImage: null,
      players: [],
      selections: {},
      heroes: {}
    }
  }

  componentDidMount() {
    const { slug } = this.props.params
    const api = new OverwatchTeamCompsApi()
    api.getComposition(slug).
      then(comp => this.onCompositionFetched(comp)).
      catch(err => CompositionView.onCompositionFetchError(err))
  }

  onCompositionFetched(composition) {
    this.setState({
      notesHTML: composition.notesHTML,
      battletag: composition.user.battletag,
      mapSegments: composition.map.segments,
      updatedAt: composition.updatedAt,
      name: composition.name,
      mapName: composition.map.name,
      players: composition.players,
      selections: composition.selections,
      heroes: composition.heroes,
      mapSlug: composition.map.slug,
      mapImage: composition.map.image
    })
  }

  compositionCreator() {
    const { battletag } = this.state
    if (typeof battletag !== 'string' || battletag.length < 1) {
      return null
    }
    return (
      <p className="composition-creator">
        By <span>{battletag}</span>
      </p>
    )
  }

  compositionDate() {
    const date = new Date(this.state.updatedAt)
    const day = date.getDay()
    const dayOfMonth = date.getDate()
    const month = date.getMonth()
    const year = date.getFullYear()
    return (
      <p
        className="composition-updated-date"
      >Updated: {days[day]}, {months[month]} {dayOfMonth}, {year}</p>
    )
  }

  render() {
    const { mapName, mapSegments, name, players, selections,
            heroes, notesHTML, mapSlug, mapImage } = this.state

    if (typeof mapName === 'undefined') {
      return <p className="container">Loading...</p>
    }

    return (
      <div>
        <header className={`composition-header gradient-${mapSlug}`}>
          <div className="container">
            <div className={`map-photo-container background-${mapSlug}`}>
              {mapImage ? (
                <img
                  src={mapImage}
                  alt={mapSlug}
                  className="map-photo"
                />
              ) : ''}
            </div>
            <div className="composition-meta">
              <div className="composition-map-name">
                {mapName}
              </div>
              <div className="composition-name">
                {name}
              </div>
              {this.compositionCreator()}
            </div>
          </div>
        </header>
        <div className="container">
          <table className="players-view-table players-table">
            <thead>
              <tr>
                <th className="players-header" />
                {mapSegments.map((segment, i) => (
                  <MapSegmentHeader
                    key={segment.id}
                    name={segment.name}
                    filled={segment.filled}
                    isAttack={segment.isAttack}
                    isFirstOfKind={segment.isFirstOfKind}
                    isLastOfKind={segment.isLastOfKind}
                    index={i}
                  />
                ))}
              </tr>
            </thead>
            <tbody>
              {players.map((player, index) => {
                const key = `${player.name}${index}`
                const playerSelections = typeof player.id === 'number' ? selections[player.id] : {}
                const playerHeroes = typeof player.id === 'number' ? heroes[player.id] : []

                return (
                  <PlayerRowView
                    key={key}
                    name={player.name}
                    heroes={playerHeroes}
                    selections={playerSelections}
                    mapSegments={mapSegments}
                  />
                )
              })}
            </tbody>
          </table>
          {notesHTML && notesHTML.length > 0 ? (
            <div className="composition-notes-wrapper">
              <p>Notes:</p>
              <div className="composition-notes">
                {renderHTML(notesHTML)}
              </div>
            </div>
          ) : ''}
          {this.compositionDate()}
        </div>
      </div>
    )
  }
}

CompositionView.propTypes = {
  params: PropTypes.object.isRequired
}

export default CompositionView
