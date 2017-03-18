class HeroPoolChoice extends React.Component {
  onChange(event) {
    this.props.onChange(event.target.value)
  }

  render() {
    const { hero, ranks } = this.props
    const rankNames = Object.keys(ranks)

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
          <div className="competitive-ranks-container">
            {rankNames.map(rankName => {
              const confidence = ranks[rankName].confidence
              const inputID = `${hero.id}${confidence}`
              return (
                <div
                  key={rankName}
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
                    className="competitive-rank-radio-label"
                  >
                    <span className="competitive-rank-text">{rankName}</span>
                  </label>
                  <label
                    htmlFor={inputID}
                    className="competitive-rank-chevron-label"
                  >
                    <img
                      alt={rankName}
                      src={ranks[rankName].image}
                      className={`competitive-rank-chevron rank-${rankName}`}
                    />
                  </label>
                </div>
              )
            })}
          </div>
        </div>
      </div>
    )
  }
}

HeroPoolChoice.propTypes = {
  hero: React.PropTypes.object.isRequired,
  onChange: React.PropTypes.func.isRequired,
  ranks: React.PropTypes.object.isRequired
}

export default HeroPoolChoice
