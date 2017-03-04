class CompositionForm extends React.Component {
  constructor() {
    super()
    const players = [
      'Player 1', 'Player 2', 'Player 3', 'Player 4', 'Player 5', 'Player 6'
    ]
    this.state = { players }
  }

  onPlayerNameChange(event, index) {
    const players = this.state.players
    players[index] = event.target.value
    this.setState({ players })
  }

  render() {
    return (
      <form className="composition-form">
        <div>
          <label htmlFor="composition_map_id">
            Map
          </label>
          <select id="composition_map_id">
            <option>Watchpoint Gibraltar</option>
          </select>
        </div>
        <div>
          <label htmlFor="composition_name">
            Composition name
          </label>
          <input
            type="text"
            placeholder="Composition name"
            id="composition_name"
          />
        </div>
        <table className="players-table">
          <thead>
            <tr>
              <th></th>
              <th>Offense Payload 1</th>
              <th>Offense Payload 2</th>
              <th>Offense Payload 3</th>
              <th>Defense Payload 1</th>
              <th>Defense Payload 2</th>
              <th>Defense Payload 3</th>
            </tr>
          </thead>
          <tbody>
            {this.state.players.map((player, index) => {
              const inputID = `player_${index}_name`
              return (
                <tr key={index}>
                  <td>
                    <label htmlFor={inputID}>Player {index + 1} name</label>
                    <input
                      type="text"
                      id={inputID}
                      placeholder="Player name"
                      value={player}
                      onChange={e => this.onPlayerNameChange(e, index)}
                    />
                  </td>
                  <td><select><option>Select hero</option></select></td>
                  <td><select><option>Select hero</option></select></td>
                  <td><select><option>Select hero</option></select></td>
                  <td><select><option>Select hero</option></select></td>
                  <td><select><option>Select hero</option></select></td>
                  <td><select><option>Select hero</option></select></td>
                </tr>
              )
            })}
          </tbody>
        </table>
        <div>
          <label htmlFor="composition_notes">
            Notes
          </label>
          <textarea
            id="composition_notes"
            placeholder="Notes for this team composition"
          ></textarea>
        </div>
      </form>
    )
  }
}
