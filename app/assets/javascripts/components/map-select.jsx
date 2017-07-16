import PropTypes from 'prop-types'
import onClickOutside from 'react-onclickoutside'

class MapSelect extends React.Component {
  constructor(props) {
    super(props)
    this.state = { isOpen: false }
  }

  onMapChange(event) {
    this.props.onChange(event.target.value)
  }

  onMenuItemClick(event, mapID) {
    event.preventDefault()
    event.target.blur()
    if (this.props.disabled) {
      return
    }
    this.setState({ isOpen: false }, () => {
      this.props.onChange(mapID)
    })
  }

  containerClass() {
    const classes = ['map-select-container menu-container']
    if (this.state.isOpen) {
      classes.push('open')
    }
    return classes.join(' ')
  }

  handleClickOutside() {
    if (this.state.isOpen) {
      this.setState({ isOpen: false })
    }
  }

  menuClass() {
    const classes = ['menu']
    if (this.props.disabled) {
      classes.push('is-disabled')
    }
    return classes.join(' ')
  }

  toggleMenuOpen(event) {
    event.target.blur()
    this.setState({ isOpen: !this.state.isOpen })
  }

  render() {
    const { selectedMapID, disabled, maps } = this.props
    const selectedMapName = maps.filter(m => m.id === selectedMapID)[0].name

    return (
      <div className={this.containerClass()}>
        <button
          type="button"
          disabled={disabled}
          className={`button menu-toggle ${disabled ? 'is-disabled' : ''}`}
          onClick={e => this.toggleMenuOpen(e)}
        >
          <i
            className="fa fa-map-marker"
            aria-hidden="true"
          /> {selectedMapName} <i className="fa fa-caret-down" aria-hidden="true" />
        </button>
        <div className={this.menuClass()}>
          {maps.map(map => {
            const isSelected = map.id === selectedMapID
            return (
              <button
                key={map.id}
                className={`map-${map.slug} menu-item button ${isSelected ? 'is-selected' : ''}`}
                onClick={e => this.onMenuItemClick(e, map.id)}
              >
                {map.name}
                {isSelected ? (
                  <i aria-hidden="true" className="fa fa-check menu-item-selected-indicator" />
                ) : ''}
              </button>
            )
          })}
        </div>
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
