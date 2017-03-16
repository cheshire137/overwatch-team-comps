import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'

class HeroPoolForm extends React.Component {
  static onHeroPoolFetchError(error) {
    console.error('failed to load hero pool', error)
  }

  componentDidMount() {
    this.loadHeroPool()
  }

  onHeroPoolLoaded(heroPool) {
    console.log('heroPool', heroPool)
  }

  loadHeroPool() {
    const api = new OverwatchTeamCompsApi()

    api.getHeroPool().
      then(heroPool => this.onHeroPoolLoaded(heroPool)).
      catch(err => HeroPoolForm.onHeroPoolFetchError(err))
  }

  render() {
    return (
      <form className="container">
        <p>Hero pool form here</p>
      </form>
    )
  }
}

HeroPoolForm.propTypes = {
  battletag: React.PropTypes.string.isRequired
}

export default HeroPoolForm
