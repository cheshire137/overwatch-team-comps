import EditPlayerSelectionRow from './edit-player-selection-row.jsx'
import MapSegmentHeader from './map-segment-header.jsx'
import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

export default class CompositionForm extends React.Component {
  static onMapsError(error) {
    console.error('failed to load maps', error)
  }

  static onCompositionFetchError(error) {
    console.error('failed to load composition data', error)
  }

  static onPlayerSelectionSaveError(error) {
    console.error('failed to save hero selection for player', error)
  }

  constructor() {
    super()
    const composition = { players: [], map: { segments: [] } }
    this.state = { maps: [], composition }
  }

  componentDidMount() {
    const api = new OverwatchTeamCompsApi()

    api.getMaps().then(maps => this.onMapsFetched(maps)).
      catch(err => CompositionForm.onMapsError(err))

    api.getLastComposition().then(comp => this.onCompositionFetched(comp)).
      catch(err => CompositionForm.onCompositionFetchError(err))
  }

  onCompositionFetched(composition) {
    this.setState({ composition })
  }

  onMapsFetched(maps) {
    this.setState({ maps })
  }

  onPlayerNameChange(event, index) {
    const players = this.state.players.slice(0)
    const player = Object.assign({}, players[index])
    player.name = event.target.value
    players[index] = player
    this.setState({ players })
  }

  onHeroSelectedForPlayer(heroID, mapSegmentID, player) {
    const { composition } = this.state
    const api = new OverwatchTeamCompsApi()

    const body = {
      hero_id: heroID,
      map_segment_id: mapSegmentID,
      player_name: player.name
    }
    if (composition.id) {
      body.composition_id = composition.id
    }

    api.savePlayerSelection(body).
      then(newComp => this.onPlayerSelectionSaved(newComp)).
      catch(err => CompositionForm.onPlayerSelectionSaveError(err))
  }

  onPlayerSelectionSaved(composition) {
    this.setState({ composition })
  }

  render() {
    const { maps, composition } = this.state
    const mapSegments = composition.map.segments
    return (
      <form className="composition-form">
        <header className="composition-form-header">
          <div className="container">
            <div className="map-photo-container" />
            <div className="composition-meta">
              <div>
                <label htmlFor="composition_map_id">
                  Choose a map:
                </label>
                <span className="select">
                  <select id="composition_map_id">
                    {maps.map(map => <option key={map.name}>{map.name}</option>)}
                  </select>
                </span>
              </div>
              <div>
                <label htmlFor="composition_name">
                  What do you want to call this team comp?
                </label>
                <input
                  type="text"
                  placeholder="Composition name"
                  id="composition_name"
                />
              </div>
            </div>
          </div>
        </header>
        <div className="container">
          <table className="players-table">
            <thead>
              <tr>
                <th className="players-header">Team 6/6</th>
                {mapSegments.map(segment =>
                  <MapSegmentHeader key={segment.id} mapSegment={segment.name} />
                )}
              </tr>
            </thead>
            <tbody>
              {composition.players.map((player, index) => {
                const inputID = `player_${index}_name`
                const key = `${player.name}${index}`
                return (
                  <EditPlayerSelectionRow
                    key={key}
                    inputID={inputID}
                    player={player}
                    mapSegments={mapSegments}
                    nameLabel={String(index + 1)}
                    onHeroSelection={(h, m) => this.onHeroSelectedForPlayer(h, m, player)}
                    onPlayerNameChange={name => this.onPlayerNameChange(name, index)}
                  />
                )
              })}
            </tbody>
          </table>
          <div className="composition-notes-wrapper">
            <label htmlFor="composition_notes">
              Notes:
            </label>
            <textarea
              id="composition_notes"
              className="textarea"
              placeholder="Notes for this team composition"
            />
            <p>
              <a
                href="https://daringfireball.net/projects/markdown/syntax"
                target="_blank"
                rel="noopener noreferrer"
              >Markdown supported</a>.
            </p>
          </div>
        </div>
      </form>
    )
  }
}
