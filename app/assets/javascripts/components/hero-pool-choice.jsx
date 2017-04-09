import PropTypes from 'prop-types'

class HeroPoolChoice extends React.Component {
  onChange(event) {
    this.props.onChange(event.target.value)
  }

  render() {
    const { slug, image, name, id, ranks, confidence } = this.props
    const rankNames = Object.keys(ranks)

    return (
      <div className="hero-pool-choice">
        <div className={`hero-pool-hero border-${slug}`}>
          <img
            src={image}
            alt={name}
            className="hero-pool-portrait"
          />
        </div>
        <div className="hero-pool-inputs-container">
          <h3
            className={`hero-pool-hero-name text-${slug}`}
          >{name}</h3>
          <div className="competitive-ranks-container">
            {rankNames.map(rankName => {
              const rankConfidence = ranks[rankName].confidence
              const inputID = `${id}${rankConfidence}`
              return (
                <div
                  key={rankName}
                  className="hero-pool-confidence-container"
                >
                  <input
                    id={inputID}
                    name={name}
                    className="hero-pool-radio"
                    type="radio"
                    checked={confidence === rankConfidence}
                    value={rankConfidence}
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
  slug: PropTypes.string.isRequired,
  image: PropTypes.string.isRequired,
  id: PropTypes.number.isRequired,
  confidence: PropTypes.number.isRequired,
  name: PropTypes.string.isRequired,
  onChange: PropTypes.func.isRequired,
  ranks: PropTypes.object.isRequired
}

export default HeroPoolChoice
