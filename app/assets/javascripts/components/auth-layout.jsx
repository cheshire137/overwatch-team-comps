class AuthLayout extends React.Component {
  render() {
    return (
      <div>
        <div className="container">
          <nav className="nav">
            <div className="nav-right">
              <a
                href="/user"
                className="nav-item"
              >Team composition</a>
              <a
                href="/user/hero-pool"
                className="nav-item"
              >Your hero pool</a>
              <span className="nav-item">Signed in as <strong></strong></span>
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
  children: React.PropTypes.object.isRequired
}

export default AuthLayout
