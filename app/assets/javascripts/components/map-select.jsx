import PropTypes from 'prop-types'

import SelectMenu from './select-menu.jsx'

const MapSelect = function(props) {
  const { selectedMapID, disabled, maps, onChange } = props
  const selectedMap = maps.filter(m => m.id === selectedMapID)[0]

  return (
    <SelectMenu
      items={maps}
      disabled={disabled}
      selectedItemID={selectedMapID}
      onChange={val => onChange(val)}
      containerClass={() => 'map-select-container'}
      menuToggleContents={() => (
        <span>
          <i
            className="fa fa-map-marker"
            aria-hidden="true"
          /> {selectedMap.name}
        </span>
      )}
      menuItemClass={map => `map-${map.slug}`}
      menuItemContent={(map, isSelected) => (
        <span className={isSelected ? 'with-selected' : ''}>
          <span className="css-truncate">{map.name}</span>
        </span>
      )}
    />
  )
}

MapSelect.propTypes = {
  disabled: PropTypes.bool.isRequired,
  selectedMapID: PropTypes.number.isRequired,
  maps: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired
}

export default MapSelect
