import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

import MapSegmentHeader from './map-segment-header.jsx'
import PlayerRowView from './player-row-view.jsx'

class CompositionView extends React.Component {
  static onCompositionFetchError(error) {
    console.error('failed to load composition data', error)
  }

  constructor(props) {
    super(props)
    this.state = {}
  }

  componentDidMount() {
    const { slug } = this.props.params
    const api = new OverwatchTeamCompsApi()
    api.getComposition(slug).
      then(comp => this.onCompositionFetched(comp)).
      catch(err => CompositionView.onCompositionFetchError(err))
  }

  onCompositionFetched(composition) {
    this.setState({ composition })
  }

  compositionCreator() {
    const battletag = this.state.composition.user.battletag
    if (typeof battletag !== 'string' || battletag.length < 1) {
      return null
    }
    return (
      <div className="composition-creator">
        By <span>{battletag}</span>
      </div>
    )
  }

  render() {
    const { composition } = this.state

    if (typeof composition === 'undefined') {
      return <p className="container">Loading...</p>
    }

    const mapSegments = composition.map.segments
    return (
      <div>
        <header className="composition-header">
          <div className="container">
            <div className="map-photo-container" />
            <div className="composition-meta">
              <div className="composition-map-name">
                {composition.map.name}
              </div>
              <div className="composition-name">
                {composition.name}
              </div>
              {this.compositionCreator()}
            </div>
          </div>
        </header>
        <div className="container">
          <table className="players-view-table players-table">
            <thead>
              <tr>
                <th className="players-header"></th>
                {mapSegments.map((segment, i) => (
                  <MapSegmentHeader
                    key={segment.id}
                    mapSegment={segment.name}
                    index={i}
                  />
                ))}
              </tr>
            </thead>
            <tbody>
              {composition.players.map((player, index) => {
                const key = `${player.name}${index}`
                const selections = typeof player.id === 'number' ? composition.selections[player.id] : {}
                const heroes = typeof player.id === 'number' ? composition.heroes[player.id] : []

                return (
                  <PlayerRowView
                    key={key}
                    player={player}
                    heroes={heroes}
                    selections={selections}
                    mapSegments={mapSegments}
                  />
                )
              })}
            </tbody>
          </table>
          <div className="composition-notes-wrapper">
            <p>Notes:</p>
            <div>
              {composition.notes}
            </div>
          </div>
        </div>
      </div>
    )
  }
}

CompositionView.propTypes = {
  params: React.PropTypes.object.isRequired
}

export default CompositionView
