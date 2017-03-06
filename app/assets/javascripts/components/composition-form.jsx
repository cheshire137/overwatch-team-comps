import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

export default class CompositionForm extends React.Component {
  static onMapsError(error) {
    console.error('failed to load maps', error)
  }

  constructor() {
    super()
    const players = [
      'Player 1', 'Player 2', 'Player 3', 'Player 4', 'Player 5', 'Player 6'
    ]
    this.state = { maps: [], players }
  }

  componentDidMount() {
    const api = new OverwatchTeamCompsApi()
    api.getMaps().then(maps => this.onMapsFetched(maps)).
      catch(err => CompositionForm.onMapsError(err))
  }

  onMapsFetched(maps) {
    this.setState({ maps })
  }

  onPlayerNameChange(event, index) {
    const players = this.state.players
    players[index] = event.target.value
    this.setState({ players })
  }

  render() {
    const { maps } = this.state
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
                <th className="attack-cell">Offense Payload 1</th>
                <th className="attack-cell">Offense Payload 2</th>
                <th className="attack-cell">Offense Payload 3</th>
                <th className="defend-cell">Defense Payload 1</th>
                <th className="defend-cell">Defense Payload 2</th>
                <th className="defend-cell">Defense Payload 3</th>
              </tr>
            </thead>
            <tbody>
              {this.state.players.map((player, index) => {
                const inputID = `player_${index}_name`
                return (
                  <tr key={inputID}>
                    <td className="player-cell">
                      <label
                        htmlFor={inputID}
                        className="label"
                      >{index + 1}</label>
                      <input
                        type="text"
                        id={inputID}
                        placeholder="Player name"
                        value={player}
                        className="input"
                        onChange={e => this.onPlayerNameChange(e, index)}
                      />
                    </td>
                    <td className="hero-select-cell">
                      <span className="select">
                        <select><option>Select hero</option></select>
                      </span>
                    </td>
                    <td className="hero-select-cell">
                      <span className="select">
                        <select><option>Select hero</option></select>
                      </span>
                    </td>
                    <td className="hero-select-cell">
                      <span className="select">
                        <select><option>Select hero</option></select>
                      </span>
                    </td>
                    <td className="hero-select-cell">
                      <span className="select">
                        <select><option>Select hero</option></select>
                      </span>
                    </td>
                    <td className="hero-select-cell">
                      <span className="select">
                        <select><option>Select hero</option></select>
                      </span>
                    </td>
                    <td className="hero-select-cell">
                      <span className="select">
                        <select><option>Select hero</option></select>
                      </span>
                    </td>
                  </tr>
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
