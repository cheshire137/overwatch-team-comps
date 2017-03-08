class MainNav extends React.Component {
  signInLink() {
    const { battletag, authPath } = this.props
    if (battletag.length > 0) {
      return (
        <span className="nav-item">Signed in as <strong>{battletag}</strong></span>
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
  authPath: React.PropTypes.string.isRequired
}

export default MainNav
