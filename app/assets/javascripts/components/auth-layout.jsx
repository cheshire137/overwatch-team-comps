import Footer from './footer.jsx'

import LocalStorage from '../models/local-storage'
import LootboxApi from '../models/lootbox-api'

class AuthLayout extends React.Component {
  static clearLocalStorage(event) {
    event.currentTarget.blur()
    LocalStorage.delete('authenticity-token')
    LocalStorage.delete('avatar')
    LocalStorage.delete('battletag')
    LocalStorage.delete('email')
    LocalStorage.delete('region')
    LocalStorage.delete('platform')
  }

  constructor(props) {
    super(props)
    this.state = {
      authenticityToken: LocalStorage.get('authenticity-token'),
      battletag: LocalStorage.get('battletag'),
      menuShown: false,
      avatar: LocalStorage.get('avatar'),
      region: LocalStorage.get('region') || 'us',
      platform: LocalStorage.get('platform') || 'pc'
    }
  }

  componentDidMount() {
    const { region, platform, battletag, avatar } = this.state

    if (typeof avatar !== 'string') {
      const api = new LootboxApi(platform, region)
      api.getProfile(battletag).then(json => {
        LocalStorage.set('avatar', json.avatar)
        this.setState({ avatar: json.avatar })
      })
    }
  }

  toggleMenu(event) {
    event.currentTarget.blur()
    this.setState({ menuShown: !this.state.menuShown })
  }

  userImage() {
    const { avatar, battletag } = this.state

    if (typeof avatar === 'string') {
      return (
        <img
          src={avatar}
          className="user-avatar"
          alt={battletag}
        />
      )
    }

    return (
      <i
        className="fa fa-user"
        aria-hidden="true"
      />
    )
  }

  userMenu() {
    const { menuShown, authenticityToken, battletag } = this.state

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
          <div className="dropdown-header">{battletag}</div>
          <div className="dropdown-divider" />
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
                title={this.state.battletag}
                onClick={e => this.toggleMenu(e)}
              >{this.userImage()}</button>
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
