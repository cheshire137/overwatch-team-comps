import PropTypes from 'prop-types'

const CompositionViewLayout = function(props) {
  return (
    <div>
      <div className="container">
        <nav className="nav">
          <div className="nav-left">
            <a
              href="/"
              className="nav-item"
            >&larr; Team composition form</a>
          </div>
        </nav>
      </div>
      <div>
        {props.children}
      </div>
    </div>
  )
}

CompositionViewLayout.propTypes = {
  children: PropTypes.object.isRequired
}

export default CompositionViewLayout
