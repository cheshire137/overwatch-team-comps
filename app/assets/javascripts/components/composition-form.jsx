import update from 'immutability-helper'

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

  static onCompositionSaveError(error) {
    console.error('failed to save composition', error)
  }

  static onPlayerCreationError(error) {
    console.error('failed to create player', error)
  }

  constructor() {
    super()
    this.state = {}
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

  onCompositionNameChange(event) {
    const name = event.target.value
    const changes = { name: { $set: name } }
    const composition = update(this.state.composition, changes)
    this.setState({ composition })
  }

  onCompositionNotesChange(event) {
    const notes = event.target.value
    const changes = { notes: { $set: notes } }
    const composition = update(this.state.composition, changes)
    this.setState({ composition })
  }

  onMapsFetched(maps) {
    this.setState({ maps })
  }

  onPlayerSelected(playerID, playerName, position) {
    const { composition } = this.state
    const api = new OverwatchTeamCompsApi()

    if (playerID) { // update existing player
      const body = {
        map_id: composition.map.id,
        player_position: position,
        player_id: playerID,
        composition_id: composition.id
      }
      api.saveComposition(body).
        then(newComp => this.onCompositionSaved(newComp)).
        catch(err => CompositionForm.onCompositionSaveError(err))
    } else { // create new player
      const body = {
        name: playerName,
        composition_id: composition.id,
        map_id: composition.map.id,
        position
      }
      api.createPlayer(body).
        then(comp => this.onCompositionSaved(comp)).
        catch(err => CompositionForm.onPlayerCreationError(err))
    }
  }

  onHeroSelectedForPlayer(heroID, mapSegmentID, player, position) {
    const { composition } = this.state
    const api = new OverwatchTeamCompsApi()

    const body = {
      hero_id: heroID,
      map_segment_id: mapSegmentID,
      player_id: player.id,
      player_name: player.name,
      player_position: position
    }
    if (composition.id) {
      body.composition_id = composition.id
    }

    api.saveComposition(body).
      then(newComp => this.onCompositionSaved(newComp)).
      catch(err => CompositionForm.onCompositionSaveError(err))
  }

  onCompositionSaved(composition) {
    this.setState({ composition })
  }

  onMapChange(event) {
    // TODO: instead, submit new map ID to server and update composition
    // when response comes back
    const mapID = parseInt(event.target.value, 10)
    const map = this.state.maps.filter(m => m.id === mapID)[0]
    const changes = { map: { $set: map } }
    const composition = update(this.state.composition, changes)
    this.setState({ composition })
  }

  render() {
    const { maps, composition } = this.state

    if (typeof maps === 'undefined' || typeof composition === 'undefined') {
      return <p>Loading...</p>
    }

    const mapSegments = composition.map.segments
    return (
      <form className="composition-form">
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
                    selectedPlayer={player}
                    players={composition.availablePlayers}
                    heroes={composition.heroes[player.id]}
                    selections={composition.selections[player.id]}
                    mapSegments={mapSegments}
                    nameLabel={String(index + 1)}
                    onHeroSelection={(heroID, mapSegmentID) =>
                      this.onHeroSelectedForPlayer(heroID, mapSegmentID, player, index)
                    }
                    onPlayerSelection={(playerID, name) =>
                      this.onPlayerSelected(playerID, name, index)
                    }
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
              value={composition.notes || ''}
              onChange={e => this.onCompositionNotesChange(e)}
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
