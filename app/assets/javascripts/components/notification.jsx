import PropTypes from 'prop-types'

class Notification extends React.Component {
  constructor(props) {
    super(props)
    this.state = { visible: true }
  }

  toggle() {
    this.setState({ visible: !this.state.visible })
  }

  render() {
    const { message, type } = this.props

    if (!this.state.visible) {
      return null
    }

    return (
      <div className={`${type}-alert container-full`}>
        <div className="container text-center">
          {message}
          <button
            type="button"
            onClick={() => this.toggle()}
          >╳</button>
        </div>
      </div>
    )
  }
}

//Display this crazy stuff
Notification.propTypes = {
  message: PropTypes.string.isRequired,
  type: PropTypes.string.isRequired
}

export default Notification
