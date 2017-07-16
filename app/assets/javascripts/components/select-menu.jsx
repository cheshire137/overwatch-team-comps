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
    if (this.props.menuClass) {
      classes.push(this.props.menuClass())
    }
    return classes.join(' ')
  }

  containerClass() {
    const classes = ['menu-container']
    if (this.state.isOpen) {
      classes.push('open')
    }
    if (this.props.containerClass) {
      classes.push(this.props.containerClass())
    }
    return classes.join(' ')
  }

  menuItemClass(item, isSelected) {
    const classes = ['menu-item button']
    if (isSelected) {
      classes.push('is-selected')
    }
    if (this.props.menuItemClass) {
      classes.push(this.props.menuItemClass(item, isSelected))
    }
    return classes.join(' ')
  }

  toggleMenuOpen(event) {
    event.target.blur()
    this.setState({ isOpen: !this.state.isOpen })
  }

  render() {
    const { items, selectedItemID, disabled, menuToggleContents } = this.props

    return (
      <div className={this.containerClass()}>
        <button
          type="button"
          disabled={disabled}
          className={`button menu-toggle${disabled ? ' is-disabled' : ''}`}
          onClick={e => this.toggleMenuOpen(e)}
        >
          {menuToggleContents()} <i
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
                {this.props.menuItemContent(item, isSelected)}
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
  // List of objects for the menu. Each should have an `id` property.
  items: PropTypes.array.isRequired,

  // Callback when a new item from the menu is chosen.
  onChange: PropTypes.func.isRequired,

  // ID of one of the `items` in the menu.
  selectedItemID: PropTypes.number,

  // Whether the menu should be disabled or not.
  disabled: PropTypes.bool.isRequired,

  // Function returning a string to be applied to the menu.
  menuClass: PropTypes.func,

  // Function returning a string to be applied to the container.
  containerClass: PropTypes.func,

  // Function returning an element that should appear in the button
  // that toggles the menu open/closed.
  menuToggleContents: PropTypes.func.isRequired,

  // Function that returns a string for the CSS class for a given
  // menu item.
  menuItemClass: PropTypes.func,

  // Function returning an element that should appear in a given
  // menu item's button.
  menuItemContent: PropTypes.func.isRequired
}

export default process.env.NODE_ENV === 'test' ? SelectMenu : onClickOutside(SelectMenu)
