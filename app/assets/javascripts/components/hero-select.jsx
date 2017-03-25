class HeroSelect extends React.Component {
  onChange(event) {
    const heroID = event.target.value
    this.props.onChange(heroID)
  }

  heroPortrait() {
    const { heroes, selectedHeroID } = this.props
    if (typeof selectedHeroID !== 'number') {
      return (
        <span className="hero-portrait-placeholder" />
      )
    }
    const hero = heroes.filter(h => h.id === selectedHeroID)[0]
    return (
      <img
        src={hero.image}
        alt={hero.name}
        className="hero-portrait"
      />
    )
  }

  render() {
    const { heroes, selectedHeroID, disabled, selectID } = this.props
    const isFilled = typeof selectedHeroID === 'number'
    return (
      <div className={`hero-select-container ${isFilled ? '' : 'not-filled'}`}>
        <label
          htmlFor={selectID}
        >{this.heroPortrait()}</label>
        <span className="select">
          <select
            onChange={e => this.onChange(e)}
            value={selectedHeroID || ''}
            disabled={disabled}
            id={selectID}
          >
            <option>Hero</option>
            {heroes.map(hero => (
              <option
                key={hero.id}
                value={hero.id}
              >{hero.name}</option>
            ))}
          </select>
        </span>
      </div>
    )
  }
}

HeroSelect.propTypes = {
  heroes: React.PropTypes.array.isRequired,
  onChange: React.PropTypes.func.isRequired,
  selectedHeroID: React.PropTypes.number,
  disabled: React.PropTypes.bool.isRequired,
  selectID: React.PropTypes.string.isRequired
}

export default HeroSelect
