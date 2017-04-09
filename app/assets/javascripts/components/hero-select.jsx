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

  selectSpanClass() {
    const classes = ['select']
    if (this.props.disabled) {
      classes.push('is-disabled')
    }
    return classes.join(' ')
  }

  isFilled() {
    return typeof this.props.selectedHeroID === 'number'
  }

  containerClass() {
    const classes = ['hero-select-container']
    if (!this.isFilled()) {
      classes.push('not-filled')
    }
    if (this.props.isDuplicate) {
      classes.push('is-duplicate')
    }
    return classes.join(' ')
  }

  render() {
    const { heroes, selectedHeroID, disabled, selectID } = this.props
    const isFilled = this.isFilled()
    return (
      <div className={this.containerClass()}>
        <label
          htmlFor={selectID}
        >{this.heroPortrait()}</label>
        <span className={this.selectSpanClass()}>
          <select
            onChange={e => this.onChange(e)}
            value={isFilled ? selectedHeroID : ''}
            disabled={disabled}
            id={selectID}
          >
            {isFilled ? '' : (
              <option value="">Hero</option>
            )}
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
  selectID: React.PropTypes.string.isRequired,
  isDuplicate: React.PropTypes.bool
}

export default HeroSelect
