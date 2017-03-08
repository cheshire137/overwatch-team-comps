class HeroSelect extends React.Component {
  onChange(event) {
    this.props.onChange(event.target.value)
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
              key={hero.name}
              value={hero.name}
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
