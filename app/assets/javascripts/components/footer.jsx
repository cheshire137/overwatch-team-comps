const Footer = function(props) {
  const { basePath } = props
  return (
    <footer className="footer">
      <div className="container">
        <a href={`${basePath}/about`}>About</a>
      </div>
    </footer>
  )
}

Footer.propTypes = {
  basePath: React.PropTypes.string.isRequired
}

export default Footer
