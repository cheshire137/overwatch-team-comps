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
    this.props.onChange(event.target.value)
  }

  render() {
    const { hero } = this.props
    const ranks = Object.keys(confidenceRanks)

    return (
      <div className="hero-pool-choice">
        <div className={`hero-pool-hero border-${hero.slug}`}>
          <img
            src={hero.image}
            alt={hero.name}
            className="hero-pool-portrait"
          />
        </div>
        <div className="hero-pool-inputs-container">
          <h3
            className={`hero-pool-hero-name text-${hero.slug}`}
          >{hero.name}</h3>
          {ranks.map(rank => {
            const confidence = confidenceRanks[rank]
            const inputID = `${hero.id}${confidence}`
            return (
              <div
                key={rank}
                className="hero-pool-confidence-container"
              >
                <input
                  id={inputID}
                  name={hero.name}
                  className="hero-pool-radio"
                  type="radio"
                  checked={hero.confidence === confidence}
                  value={confidence}
                  onChange={e => this.onChange(e)}
                />
                <label
                  htmlFor={inputID}
                >{rank}</label>
              </div>
            )
          })}
        </div>
      </div>
    )
  }
}

HeroPoolChoice.propTypes = {
  hero: React.PropTypes.object.isRequired,
  onChange: React.PropTypes.func.isRequired
}

export default HeroPoolChoice
