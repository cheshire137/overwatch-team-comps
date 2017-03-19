class HeroSelect extends React.Component {
  onChange(event) {
    const heroID = event.target.value
    this.props.onChange(heroID)
  }

  heroPortrait() {
    const { heroes, selectedHeroID } = this.props
    if (typeof selectedHeroID !== 'number') {
      return (
        <span className="hero-portrait-placeholder">
          <i className="fa fa-user-o" aria-hidden="true"></i>
        </span>
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
    const { heroes, selectedHeroID, disabled } = this.props
    return (
      <div>
        {this.heroPortrait()}
        <span className="select">
          <select
            onChange={e => this.onChange(e)}
            value={selectedHeroID || ''}
            disabled={disabled}
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
  disabled: React.PropTypes.bool.isRequired
}

export default HeroSelect
