import CompositionFormHeader from './composition-form-header.jsx'
import EditPlayerSelectionRow from './edit-player-selection-row.jsx'
import MapSegmentHeader from './map-segment-header.jsx'
import PlayerEditModal from './player-edit-modal.jsx'

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
    this.state = {
      id: null,
      name: '',
      slug: '',
      mapID: null,
      mapSlug: '',
      mapSegments: [],
      players: [],
      availablePlayers: [],
      heroes: {},
      selections: {},
      notes: '',
      editingPlayerID: null
    }
  }

  componentDidMount() {
    this.loadComposition()
  }

  onMapChange(mapID) {
    this.loadComposition(mapID)
  }

  onCompositionNameChange(name) {
    const { id, mapID } = this.state
    const api = new OverwatchTeamCompsApi()

    const body = {
      name,
      map_id: mapID
    }
    if (id) {
      body.composition_id = id
    }

    api.saveComposition(body).
      then(newComp => this.onCompositionLoaded(newComp)).
      catch(err => CompositionForm.onCompositionSaveError(err))
  }

  onCompositionNotesChange(event) {
    // TODO: actually POST this to the server to save the value,
    // but not as the user types because we don't want a request
    // going for every keystroke
    this.setState({ notes: event.target.value })
  }

  onPlayerSelected(playerID, playerName, position) {
    if (playerID) {
      this.updatePlayer(playerID, position)
    } else {
      this.createPlayer(playerName, position)
    }
  }

  onHeroSelectedForPlayer(heroID, mapSegmentID, playerID, position) {
    const { id } = this.state
    const api = new OverwatchTeamCompsApi()

    const body = {
      hero_id: heroID,
      map_segment_id: mapSegmentID,
      player_id: playerID,
      player_position: position
    }
    if (id) {
      body.composition_id = id
    }

    api.saveComposition(body).
      then(newComp => this.onCompositionLoaded(newComp)).
      catch(err => CompositionForm.onCompositionSaveError(err))
  }

  onCompositionLoaded(composition) {
    this.setState({
      id: composition.id,
      name: composition.name,
      slug: composition.slug,
      mapID: composition.map.id,
      mapSlug: composition.map.slug,
      mapSegments: composition.map.segments,
      players: composition.players,
      availablePlayers: composition.availablePlayers,
      heroes: composition.heroes,
      selections: composition.selections,
      notes: composition.notes
    })
  }

  // Returns a list of players. Includes only players not selected in
  // other rows. Always includes the given player.
  getPlayerOptionsForRow(playerForRow) {
    const { availablePlayers, players } = this.state
    const playerIDsInComp = players.map(player => player.id)
    return availablePlayers.filter(player =>
      playerIDsInComp.indexOf(player.id) < 0 || player.id === playerForRow.id
    )
  }

  loadComposition(mapID) {
    const api = new OverwatchTeamCompsApi()

    api.getLastComposition(mapID).
      then(comp => this.onCompositionLoaded(comp)).
      catch(err => CompositionForm.onCompositionFetchError(err))
  }

  createPlayer(playerName, position) {
    const { id, mapID } = this.state
    const body = {
      name: playerName,
      composition_id: id,
      map_id: mapID,
      position
    }
    const api = new OverwatchTeamCompsApi()
    api.createPlayer(body).
      then(comp => this.onCompositionLoaded(comp)).
      catch(err => CompositionForm.onPlayerCreationError(err))
  }

  updatePlayer(playerID, position) {
    const { mapID, id } = this.state
    const body = {
      map_id: mapID,
      player_position: position,
      player_id: playerID,
      composition_id: id
    }
    const api = new OverwatchTeamCompsApi()
    api.saveComposition(body).
      then(newComp => this.onCompositionLoaded(newComp)).
      catch(err => CompositionForm.onCompositionSaveError(err))
  }

  editPlayer(playerID) {
    this.setState({ editingPlayerID: playerID })
  }

  closePlayerEditModal(newComposition) {
    this.editPlayer(null)
    if (newComposition) {
      this.onCompositionLoaded(newComposition)
    }
  }

  selectedPlayerCount() {
    return this.state.players.
      filter(p => typeof p.id === 'number').length
  }

  render() {
    const { name, slug, mapID, mapSegments, players, heroes,
            selections, notes, mapSlug, editingPlayerID, id } = this.state

    if (typeof mapID !== 'number') {
      return <p className="container">Loading...</p>
    }

    const editingPlayer = typeof editingPlayerID === 'number'
      ? players.filter(p => p.id === editingPlayerID)[0]
      : null

    return (
      <form className="composition-form">
        <CompositionFormHeader
          name={name}
          slug={slug}
          mapID={mapID}
          mapSlug={mapSlug}
          onNameChange={newName => this.onCompositionNameChange(newName)}
          onMapChange={newMapID => this.onMapChange(newMapID)}
        />
        <div className="container">
          <table className="players-table">
            <thead>
              <tr>
                <th className="players-header small-fat-header">
                  <span className="player-count">
                    {this.selectedPlayerCount()} / 6
                  </span>
                  Team
                </th>
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
                const inputID = `player_${index}_name`
                const key = `${player.name}${index}`
                const playerHeroes = typeof player.id === 'number' ? heroes[player.id] : []
                const playerSelections = typeof player.id === 'number' ? selections[player.id] : {}
                const selectablePlayers = this.getPlayerOptionsForRow(player)

                return (
                  <EditPlayerSelectionRow
                    key={key}
                    inputID={inputID}
                    playerID={player.id}
                    players={selectablePlayers}
                    heroes={playerHeroes}
                    selections={playerSelections}
                    mapSegments={mapSegments}
                    nameLabel={String(index + 1)}
                    onHeroSelection={(heroID, mapSegmentID) =>
                      this.onHeroSelectedForPlayer(heroID, mapSegmentID, player.id, index)
                    }
                    onPlayerSelection={(playerID, newName) =>
                      this.onPlayerSelected(playerID, newName, index)
                    }
                    editPlayer={playerID => this.editPlayer(playerID)}
                  />
                )
              })}
            </tbody>
          </table>
          <div className="composition-notes-wrapper">
            <label
              htmlFor="composition_notes"
              className="label notes-label small-fat-header"
            >Notes</label>
            <textarea
              id="composition_notes"
              className="textarea"
              placeholder="Notes for this team composition"
              value={notes || ''}
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
        <PlayerEditModal
          playerID={editingPlayerID}
          playerName={editingPlayer ? editingPlayer.name : ''}
          battletag={editingPlayer ? editingPlayer.battletag : ''}
          close={newComp => this.closePlayerEditModal(newComp)}
          compositionID={id}
          isOpen={typeof editingPlayerID === 'number'}
        />
      </form>
    )
  }
}
