import OverwatchTeamCompsApi from '../models/overwatch-team-comps-api'
import HeroPoolChoice from './hero-pool-choice.jsx'

class HeroPoolForm extends React.Component {
  static onHeroPoolFetchError(error) {
    console.error('failed to load hero pool', error)
  }

  static onHeroPoolSaveError(error) {
    console.error('failed to save your hero confidence', error)
  }

  constructor(props) {
    super(props)

    this.state = { heroes: [], ranks: {} }
  }

  componentDidMount() {
    this.loadHeroPool()
  }

  onHeroPoolLoaded(heroPool) {
    this.setState({ heroes: heroPool.heroes, ranks: heroPool.ranks })
  }

  onConfidenceChange(heroID, confidence) {
    const body = {
      hero_id: heroID,
      confidence
    }
    const api = new OverwatchTeamCompsApi()
    api.saveHeroPool(body).
      then(heroPool => this.onHeroPoolLoaded(heroPool)).
      catch(err => HeroPoolForm.onHeroPoolSaveError(err))
  }

  loadHeroPool() {
    const api = new OverwatchTeamCompsApi()
    api.getHeroPool().
      then(heroPool => this.onHeroPoolLoaded(heroPool)).
      catch(err => HeroPoolForm.onHeroPoolFetchError(err))
  }

  render() {
    const { heroes, ranks } = this.state
    if (heroes.length < 1) {
      return <p className="container">Loading...</p>
    }

    return (
      <form className="hero-pool-form">
        <p>Rank your ability on each hero.</p>
        <div>
          {heroes.map(hero => (
            <HeroPoolChoice
              hero={hero}
              key={hero.id}
              ranks={ranks}
              onChange={confidence => this.onConfidenceChange(hero.id, confidence)}
            />
          ))}
        </div>
      </form>
    )
  }
}

HeroPoolForm.propTypes = {
  battletag: React.PropTypes.string.isRequired
}

export default HeroPoolForm
