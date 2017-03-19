const AnonLayout = function(props) {
  return (
    <div>
      <div className="container">
        <nav className="nav">
          <div className="nav-right">
            <a
              href="/users/auth/bnet"
              className="nav-item"
            >Sign in with Battle.net</a>
          </div>
        </nav>
      </div>
      <div>
        {props.children}
      </div>
      <footer className="footer">
        <div className="container">
          <a href="/about">About</a>
        </div>
      </footer>
    </div>
  )
}

AnonLayout.propTypes = {
  children: React.PropTypes.object.isRequired
}

export default AnonLayout
