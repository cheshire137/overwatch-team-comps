import Footer from './footer.jsx'

import LocalStorage from '../models/local-storage'

class AuthLayout extends React.Component {
  static clearLocalStorage(event) {
    event.currentTarget.blur()
    LocalStorage.delete('authenticity-token')
    LocalStorage.delete('battletag')
  }

  constructor(props) {
    super(props)
    this.state = {
      authenticityToken: LocalStorage.get('authenticity-token'),
      battletag: LocalStorage.get('battletag'),
      menuShown: false
    }
  }

  toggleMenu(event) {
    event.currentTarget.blur()
    this.setState({ menuShown: !this.state.menuShown })
  }

  userMenu() {
    const { menuShown, authenticityToken } = this.state

    if (!menuShown) {
      return null
    }

    return (
      <div className="dropdown-menu-content" aria-hidden="false" aria-expanded="true">
        <form
          action="/users/sign_out"
          method="post"
          className="dropdown-menu"
        >
          <input name="_method" type="hidden" value="delete" />
          <input name="authenticity_token" type="hidden" value={authenticityToken} />
          <button
            className="dropdown-item"
            type="submit"
            onClick={e => AuthLayout.clearLocalStorage(e)}
          >Sign out</button>
        </form>
      </div>
    )
  }

  render() {
    const path = this.props.location.pathname
    return (
      <div className="layout-container">
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
              <button
                className="nav-item"
                type="button"
                onClick={e => this.toggleMenu(e)}
              >Signed in as <strong>{this.state.battletag}</strong></button>
              {this.userMenu()}
            </div>
          </nav>
        </div>
        <div className="layout-children-container">
          {this.props.children}
        </div>
        <Footer basePath="/user" />
      </div>
    )
  }
}

AuthLayout.propTypes = {
  children: React.PropTypes.object.isRequired,
  location: React.PropTypes.object.isRequired
}

export default AuthLayout
