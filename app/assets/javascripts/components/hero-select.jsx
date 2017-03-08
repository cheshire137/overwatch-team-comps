class HeroSelect extends React.Component {
  onChange(event) {
    const heroID = event.target.value
    this.props.onChange(heroID)
  }

  render() {
    const { heroes } = this.props
    return (
      <span className="select">
        <select
          onChange={e => this.onChange(e)}
        >
          <option>Select hero</option>
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
  onChange: React.PropTypes.func.isRequired
}

export default HeroSelect
