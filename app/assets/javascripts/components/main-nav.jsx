class MainNav extends React.Component {
  compositionFormLinkClass() {
    let className = 'nav-item'
    if (this.props.activeView === 'composition-form') {
      className += ' is-active'
    }
    return className
  }

  heroPoolFormLinkClass() {
    let className = 'nav-item'
    if (this.props.activeView === 'hero-pool-form') {
      className += ' is-active'
    }
    return className
  }

  signInLink() {
    const { battletag, authPath } = this.props
    if (battletag.length > 0) { // authenticated
      return (
        <div>
          <a
            href="/"
            className={this.compositionFormLinkClass()}
          >Team composition</a>
          <a
            href="/hero-pool"
            className={this.heroPoolFormLinkClass()}
          >Your hero pool</a>
          <span className="nav-item">Signed in as <strong>{battletag}</strong></span>
        </div>
      )
    }

    return (
      <a
        href={authPath}
        className="nav-item"
      >Sign in with Battle.net</a>
    )
  }

  render() {
    return (
      <div className="container">
        <nav className="nav">
          <div className="nav-right">
            {this.signInLink()}
          </div>
        </nav>
      </div>
    )
  }
}

MainNav.propTypes = {
  battletag: React.PropTypes.string.isRequired,
  authPath: React.PropTypes.string.isRequired,
  activeView: React.PropTypes.string.isRequired
}

export default MainNav
