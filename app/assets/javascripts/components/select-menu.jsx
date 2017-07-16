import PropTypes from 'prop-types'
import onClickOutside from 'react-onclickoutside'

class SelectMenu extends React.Component {
  constructor(props) {
    super(props)
    this.state = { isOpen: false }
  }

  onMenuItemClick(event, newValue) {
    event.preventDefault()
    event.target.blur()
    if (this.props.disabled) {
      return
    }
    this.setState({ isOpen: false }, () => {
      this.props.onChange(newValue)
    })
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

  containerClass() {
    const classes = ['menu-container']
    if (this.state.isOpen) {
      classes.push('open')
    }
    return classes.join(' ')
  }

  menuItemClass(item, isSelected) {
    return `menu-item button ${isSelected ? 'is-selected' : ''}`
  }

  // Override in child classes
  menuItemContent() {
    return <span>Item</span>
  }

  // Override in child classes
  menuToggleContents() {
    return <span>Menu</span>
  }

  toggleMenuOpen(event) {
    event.target.blur()
    this.setState({ isOpen: !this.state.isOpen })
  }

  render() {
    const { items, selectedItemID, disabled } = this.props

    return (
      <div className={this.containerClass()}>
        <button
          type="button"
          disabled={disabled}
          className={`button menu-toggle ${disabled ? 'is-disabled' : ''}`}
          onClick={e => this.toggleMenuOpen(e)}
        >
          {this.menuToggleContents()} <i
            aria-hidden="true"
            className="fa fa-caret-down"
          />
        </button>
        <div className={this.menuClass()}>
          {items.map(item => {
            const isSelected = item.id === selectedItemID
            return (
              <button
                key={item.id}
                className={this.menuItemClass(item, isSelected)}
                onClick={e => this.onMenuItemClick(e, item.id)}
              >
                {this.menuItemContent()}
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

SelectMenu.propTypes = {
  items: PropTypes.array.isRequired,
  onChange: PropTypes.func.isRequired,
  selectedItemID: PropTypes.number,
  disabled: PropTypes.bool.isRequired
}

export default process.env.NODE_ENV === 'test' ? SelectMenu : onClickOutside(SelectMenu)
