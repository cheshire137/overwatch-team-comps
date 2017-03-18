import LocalStorage from '../models/local-storage'

class AuthLayout extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      battletag: LocalStorage.get('battletag')
    }
  }

  render() {
    const path = this.props.location.pathname
    return (
      <div>
        <div className="container">
          <nav className="nav">
            <div className="nav-right">
              <a
                href="/user"
                className={`nav-item ${path === '/user' ? 'is-active' : ''}`}
              >Team composition</a>
              <a
                href="/user/hero-pool"
                className={`nav-item ${path === '/user/hero-pool' ? 'is-active' : ''}`}
              >Your hero pool</a>
              <span className="nav-item">
                Signed in as <strong>{this.state.battletag}</strong>
              </span>
            </div>
          </nav>
        </div>
        <div>
          {this.props.children}
        </div>
      </div>
    )
  }
}

AuthLayout.propTypes = {
  children: React.PropTypes.object.isRequired,
  location: React.PropTypes.object.isRequired
}

export default AuthLayout
