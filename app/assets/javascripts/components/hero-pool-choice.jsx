const confidenceRanks = {
  bronze: 0,
  silver: 15,
  gold: 30,
  platinum: 45,
  diamond: 60,
  master: 75,
  grandmaster: 100
}

class HeroPoolChoice extends React.Component {
  onChange(event) {
    console.log(this.props.hero.name, event.target.value)
  }

  render() {
    const { hero } = this.props
    const ranks = Object.keys(confidenceRanks)

    return (
      <div key={hero.id}>
        <div className="hero-pool-hero">{hero.name}</div>
        <div className="hero-pool-inputs-container">
          {ranks.map(rank => (
            <div
              key={rank}
              className="hero-pool-confidence-container"
            >
              <input
                name={hero.name}
                type="radio"
                checked={hero.confidence === confidenceRanks[rank]}
                value={confidenceRanks[rank]}
                onChange={e => this.onChange(e)}
              />
            </div>
          ))}
        </div>
      </div>
    )
  }
}

HeroPoolChoice.propTypes = {
  hero: React.PropTypes.object.isRequired
}

export default HeroPoolChoice
