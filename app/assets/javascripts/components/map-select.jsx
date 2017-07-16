import PropTypes from 'prop-types'
import onClickOutside from 'react-onclickoutside'

class MapSelect extends React.Component {
  onMapChange(event) {
    this.props.onChange(event.target.value)
  }

  handleClickOutside() {
  }

  render() {
    const { selectedMapID, disabled, maps } = this.props
    const className = `select map-select ${disabled ? 'is-disabled' : ''}`

    return (
      <div className="map-select-container">
        <label
          htmlFor="composition_map_id"
        ><i className="fa fa-map-marker" aria-hidden="true" /></label>
        <span className={className}>
          <select
            aria-label="Choose a map"
            title="Choose a map"
            id="composition_map_id"
            value={selectedMapID}
            onChange={e => this.onMapChange(e)}
            disabled={disabled}
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
    )
  }
}

MapSelect.propTypes = {
  disabled: PropTypes.bool.isRequired,
  selectedMapID: PropTypes.number.isRequired,
  maps: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired
}

export default process.env.NODE_ENV === 'test' ? MapSelect : onClickOutside(MapSelect)
