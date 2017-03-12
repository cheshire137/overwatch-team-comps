import DebounceInput from 'react-debounce-input'

class PlayerSelect extends React.Component {
  onChange(event) {
    this.props.onChange(event.target.value)
  }

  render() {
    const { inputID, player, label } = this.props
    return (
      <div>
        <label
          htmlFor={inputID}
          className="label"
        >{label}</label>
        <DebounceInput
          debounceTimeout={500}
          onChange={e => this.onChange(e)}
          id={inputID}
          placeholder="Player name"
          value={player.name}
          className="input"
        />
      </div>
    )
  }
}

PlayerSelect.propTypes = {
  inputID: React.PropTypes.string.isRequired,
  player: React.PropTypes.object.isRequired,
  onChange: React.PropTypes.func.isRequired,
  label: React.PropTypes.string.isRequired
}

export default PlayerSelect
