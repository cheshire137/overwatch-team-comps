class MainNav extends React.Component {
  signInLink() {
    const { battletag, authPath } = this.props
    if (battletag.length > 0) {
      return <span>Signed in as <strong>{battletag}</strong></span>
    }

    return <a href={authPath}>Sign in with Battle.net</a>
  }

  render() {
    return (
      <nav>
        {this.signInLink()}
      </nav>
    )
  }
}

MainNav.propTypes = {
  battletag: React.PropTypes.string.isRequired,
  authPath: React.PropTypes.string.isRequired
}

export default MainNav
