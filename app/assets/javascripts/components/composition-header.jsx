import update from 'immutability-helper'

import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

class CompositionHeader extends React.Component {
  static onMapsError(error) {
    console.error('failed to load maps', error)
  }

  constructor(props) {
    super(props)
    this.state = {}
  }

  componentDidMount() {
    const api = new OverwatchTeamCompsApi()

    api.getMaps().then(maps => this.onMapsFetched(maps)).
      catch(err => CompositionHeader.onMapsError(err))
  }

  onMapsFetched(maps) {
    this.setState({ maps })
  }

  onMapChange(event) {
    // TODO: instead, submit new map ID to server and update composition
    // when response comes back
    const mapID = parseInt(event.target.value, 10)
    // const map = this.state.maps.filter(m => m.id === mapID)[0]
    // const changes = { map: { $set: map } }
    // const composition = update(this.state.composition, changes)
    // this.setState({ composition })
  }

  render() {
    const { maps } = this.state
    if (typeof maps === 'undefined') {
      return null
    }

    const { composition } = this.props
    return (
      <header className="composition-form-header">
        <div className="container">
          <div className="map-photo-container" />
          <div className="composition-meta">
            <div>
              <span className="select map-select">
                <select
                  aria-label="Choose a map"
                  id="composition_map_id"
                  value={composition.map.id}
                  onChange={e => this.onMapChange(e)}
                >
                  {maps.map(map =>
                    <option
                      key={map.id}
                      value={map.id}
                    >{map.name}</option>
                  )}
                </select>
              </span>
            </div>
            <div className="composition-name-container">
              <i
                className="fa fa-pencil-square-o"
                aria-hidden="true"
              />
              <input
                type="text"
                className="input composition-name-input"
                placeholder="Composition name"
                id="composition_name"
                value={composition.name || ''}
                onChange={e => this.onCompositionNameChange(e)}
                aria-label="Name of this team composition"
              />
            </div>
          </div>
        </div>
      </header>
    )
  }
}

CompositionHeader.propTypes = {
  composition: React.PropTypes.object.isRequired
}

export default CompositionHeader
