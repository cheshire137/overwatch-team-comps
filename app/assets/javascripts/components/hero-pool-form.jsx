import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'
import HeroPoolChoice from './hero-pool-choice.jsx'

class HeroPoolForm extends React.Component {
  static onHeroPoolFetchError(error) {
    console.error('failed to load hero pool', error)
  }

  constructor(props) {
    super(props)

    this.state = { heroes: [] }
  }

  componentDidMount() {
    this.loadHeroPool()
  }

  onHeroPoolLoaded(heroPool) {
    console.log('heroPool', heroPool)
    this.setState({ heroes: heroPool.heroes })
  }

  loadHeroPool() {
    const api = new OverwatchTeamCompsApi()

    api.getHeroPool().
      then(heroPool => this.onHeroPoolLoaded(heroPool)).
      catch(err => HeroPoolForm.onHeroPoolFetchError(err))
  }

  render() {
    const { heroes } = this.state
    if (heroes.length < 1) {
      return <p className="container">Loading...</p>
    }

    return (
      <form className="container">
        {heroes.map(hero => <HeroPoolChoice hero={hero} key={hero.id} />)}
      </form>
    )
  }
}

HeroPoolForm.propTypes = {
  battletag: React.PropTypes.string.isRequired
}

export default HeroPoolForm
