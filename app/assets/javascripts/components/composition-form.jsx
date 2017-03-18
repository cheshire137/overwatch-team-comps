import update from 'immutability-helper'

import CompositionFormHeader from './composition-form-header.jsx'
import EditPlayerSelectionRow from './edit-player-selection-row.jsx'
import MapSegmentHeader from './map-segment-header.jsx'
import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

export default class CompositionForm extends React.Component {
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
    this.loadComposition()
  }

  onCompositionFetched(composition) {
    this.setState({ composition })
  }

  onMapChange(mapID) {
    this.loadComposition(mapID)
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

  onPlayerSelected(playerID, playerName, position) {
    if (playerID) {
      this.updatePlayer(playerID, position)
    } else {
      this.createPlayer(playerName, position)
    }
  }

  onHeroSelectedForPlayer(heroID, mapSegmentID, playerID, position) {
    const { composition } = this.state
    const api = new OverwatchTeamCompsApi()

    const body = {
      hero_id: heroID,
      map_segment_id: mapSegmentID,
      player_id: playerID,
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

  // Returns a list of players. Includes only players not selected in
  // other rows. Always includes the given player.
  getPlayerOptionsForRow(playerForRow) {
    const { composition } = this.state
    const { availablePlayers, players } = composition
    const playerIDsInComp = players.map(player => player.id)
    return availablePlayers.filter(player =>
      playerIDsInComp.indexOf(player.id) < 0 || player.id === playerForRow.id
    )
  }

  loadComposition(mapID) {
    const api = new OverwatchTeamCompsApi()

    api.getLastComposition(mapID).
      then(comp => this.onCompositionFetched(comp)).
      catch(err => CompositionForm.onCompositionFetchError(err))
  }

  createPlayer(playerName, position) {
    const { composition } = this.state
    const body = {
      name: playerName,
      composition_id: composition.id,
      map_id: composition.map.id,
      position
    }
    const api = new OverwatchTeamCompsApi()
    api.createPlayer(body).
      then(comp => this.onCompositionSaved(comp)).
      catch(err => CompositionForm.onPlayerCreationError(err))
  }

  updatePlayer(playerID, position) {
    const { composition } = this.state
    const body = {
      map_id: composition.map.id,
      player_position: position,
      player_id: playerID,
      composition_id: composition.id
    }
    const api = new OverwatchTeamCompsApi()
    api.saveComposition(body).
      then(newComp => this.onCompositionSaved(newComp)).
      catch(err => CompositionForm.onCompositionSaveError(err))
  }

  render() {
    const { composition } = this.state

    if (typeof composition === 'undefined') {
      return <p className="container">Loading...</p>
    }

    const mapSegments = composition.map.segments
    return (
      <form className="composition-form">
        <CompositionFormHeader
          composition={composition}
          onMapChange={mapID => this.onMapChange(mapID)}
        />
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
                const heroes = typeof player.id === 'number' ? composition.heroes[player.id] : []
                const selections = typeof player.id === 'number' ? composition.selections[player.id] : {}
                const players = this.getPlayerOptionsForRow(player)

                return (
                  <EditPlayerSelectionRow
                    key={key}
                    inputID={inputID}
                    selectedPlayer={player}
                    players={players}
                    heroes={heroes}
                    selections={selections}
                    mapSegments={mapSegments}
                    nameLabel={String(index + 1)}
                    onHeroSelection={(heroID, mapSegmentID) =>
                      this.onHeroSelectedForPlayer(heroID, mapSegmentID, player.id, index)
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
