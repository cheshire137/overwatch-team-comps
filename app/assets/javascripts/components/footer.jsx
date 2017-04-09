import PropTypes from 'prop-types'

const Footer = function(props) {
  const { basePath } = props
  return (
    <footer className="footer">
      <div className="container">
        <a href={`${basePath}/about`}>About</a>
        <a
          href="https://github.com/cheshire137/overwatch-team-comps"
          target="_blank"
          rel="noopener noreferrer"
        >View source</a>
      </div>
    </footer>
  )
}

Footer.propTypes = {
  basePath: PropTypes.string.isRequired
}

export default Footer
