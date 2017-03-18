import CompositionForm from './composition-form.jsx'
import HeroPoolForm from './hero-pool-form.jsx'
import MainNav from './main-nav.jsx'

class App extends React.Component {
  constructor(props) {
    super(props)

    let activeView = 'composition-form'
    const route = window.location.pathname
    if (route === '/hero-pool') {
      if (props.battletag) {
        activeView = 'hero-pool-form'
      } else {
        window.location.href = '/'
      }
    }

    this.state = { activeView }
  }

  renderActiveView() {
    if (this.state.activeView === 'hero-pool-form') {
      return <HeroPoolForm battletag={this.props.battletag} />
    }

    return <CompositionForm />
  }

  render() {
    const { battletag, authPath } = this.props
    return (
      <div>
        <MainNav
          battletag={battletag}
          authPath={authPath}
          activeView={this.state.activeView}
        />
        {this.renderActiveView()}
      </div>
    )
  }
}

App.propTypes = {
  battletag: React.PropTypes.string.isRequired,
  authPath: React.PropTypes.string.isRequired
}

export default App
