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
      <div className="hero-pool-choice">
        <div className="hero-pool-hero">{hero.name}</div>
        <div className="hero-pool-inputs-container">
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
  hero: React.PropTypes.object.isRequired
}

export default HeroPoolChoice
