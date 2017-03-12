class HeroSelect extends React.Component {
  onChange(event) {
    const heroID = event.target.value
    this.props.onChange(heroID)
  }

  render() {
    const { heroes, selectedHeroID, disabled } = this.props
    return (
      <span className="select">
        <select
          onChange={e => this.onChange(e)}
          value={selectedHeroID || ''}
          disabled={disabled}
        >
          <option>&mdash;</option>
          {heroes.map(hero => (
            <option
              key={hero.id}
              value={hero.id}
            >{hero.name}</option>
          ))}
        </select>
      </span>
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
