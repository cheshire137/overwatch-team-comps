import Footer from './footer.jsx'

const AnonLayout = function(props) {
  const path = props.location.pathname
  return (
    <div className="layout-container">
      <div className="container">
        <nav className="nav">
          <div className="nav-right">
            {path === '/about' ? (
              <a
                href="/"
                className="nav-item"
              >Team composition</a>
            ) : ''}
            <a
              href="/users/auth/bnet"
              className="nav-item"
            >Sign in with Battle.net</a>
          </div>
        </nav>
      </div>
      <div className="layout-children-container">
        {props.children}
      </div>
      <Footer basePath="" />
    </div>
  )
}

AnonLayout.propTypes = {
  children: React.PropTypes.object.isRequired,
  location: React.PropTypes.object.isRequired
}

export default AnonLayout
