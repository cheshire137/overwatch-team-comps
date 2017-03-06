import CompositionForm from './composition-form.jsx'
import MainNav from './main-nav.jsx'

const App = function(props) {
  const { battletag, authPath } = props
  return (
    <div>
      <MainNav battletag={battletag} authPath={authPath} />
      <CompositionForm />
    </div>
  )
}

App.propTypes = {
  battletag: React.PropTypes.string.isRequired,
  authPath: React.PropTypes.string.isRequired
}

export default App
