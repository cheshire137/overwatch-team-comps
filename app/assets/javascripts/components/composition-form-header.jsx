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
    this.props.onMapChange(event.target.value)
  }

  render() {
    const { maps } = this.state
    if (typeof maps === 'undefined') {
      return null
    }

    const { composition } = this.props
    return (
      <header className={`composition-header background-${composition.map.slug}`}>
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
            <div className="composition-link-container">
              <a
                href={`/comp/${composition.slug}`}
                className="composition-link"
              >
                <i
                  className="fa fa-link"
                  aria-hidden="true"
                />
                Share this composition
              </a>
            </div>
          </div>
        </div>
      </header>
    )
  }
}

CompositionHeader.propTypes = {
  composition: React.PropTypes.object.isRequired,
  onMapChange: React.PropTypes.func.isRequired
}

export default CompositionHeader
